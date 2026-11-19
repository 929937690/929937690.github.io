# frozen_string_literal: true
#
# Site-local extensions for jekyll-scholar (see NOTES.md):
#
#   1. Ruby 3.x compatibility patch for bibtex-ruby 4.4.7
#      (BibTeX::Bibliography#each used `Proc.new` without a block, which was
#      removed in Ruby 3.0 and breaks every `--query` filter).
#
#   2. Pre-parse fix-up: strip trailing "% ..." comments that appear INSIDE
#      entries (e.g. the `presort = {mk},  % hand-order ...` lines).
#      bibtex-ruby's lexer chokes on those and silently drops the entry.
#      Doing it here keeps _bibliography/publications.bib byte-identical to
#      the canonical cv-yuntaoli/publications.bib.
#
#   3. Stable sort: jekyll-scholar uses Array#sort (unstable), so entries that
#      tie on every sort key (same year, no presort) could swap randomly.
#      This patch falls back to .bib file order — matching the CV.
#
#   4. Liquid filters used by _layouts/bib_entry.html:
#        scholar_strip_number  - removes the leading "[n]" the IEEE CSL style
#                                emits (numbering is done with CSS counters so
#                                it can run continuously across groups).
#        scholar_cofirst: key  - appends <sup>*</sup> to co-first authors as
#                                declared by the biblatex annotation
#                                `author+an = {1=cofirst; 2=cofirst; ...}`
#                                (parsed from the raw .bib entry via regex).
#        scholar_bold_author   - wraps Yuntao Li / Y. Li / Li, Y. in <strong>.

require 'bibtex'

# ---------------------------------------------------------------- (1)
module BibTeX
  class Bibliography
    def each(&block)
      if block
        data.each(&block)
        self
      else
        to_enum
      end
    end

    def each_entry(&block)
      if block
        q('@entry').each(&block)
      else
        q('@entry').to_enum
      end
    end
  end

  class Entry
    def each(&block)
      if block
        fields.each(&block)
        self
      else
        to_enum
      end
    end
    alias each_pair each

    def convert(*filters, &block)
      block ? dup.convert!(*filters, &block) : dup.convert!(*filters)
    end

    # The IEEE CSL style only prints the container-title of a
    # "paper-conference" item when pages/editors/volume are present;
    # otherwise it falls back to "presented at <event>". Our bib entries
    # carry the venue in booktitle only, so remap conference papers to
    # "chapter", which IEEE renders as: "Title," in <i>Booktitle</i>, year.
    alias_method :to_citeproc_without_venue_fix, :to_citeproc
    def to_citeproc(options = {})
      hash = to_citeproc_without_venue_fix(options)
      if hash['type'] == 'paper-conference' && hash['container-title']
        hash['type'] = 'chapter'
      end
      hash
    end
  end

  # Ruby 3.4 defines String#dup as an own method, so bibtex-ruby's
  #   def_delegators :to_s, *String.instance_methods(false)...
  # now (wrongly) delegates #dup to the string representation, which breaks
  # Value#convert on author names. Restore real Struct duplication.
  class Name
    def dup
      self.class.new(Hash[each_pair.to_a])
    end
  end
end

module Jekyll
  class Scholar
    module Utilities
      # ------------------------------------------------------------ (2)
      def bibliography
        unless @bibliography
          raw = bibtex_paths.reduce(+'') { |s, p| s << IO.read(p) }
          # Strip trailing % comments after a completed field ("...},  % note")
          raw = raw.gsub(/^(.*\},?)[ \t]+%[^\n]*$/, '\1')
          @bibliography = BibTeX::Bibliography.parse(raw, bibtex_options)
          @bibliography.replace_strings if replace_strings?
          @bibliography.join if join_strings? && replace_strings?
        end
        @bibliography
      end

      # ------------------------------------------------------------ (3)
      def sort(unsorted)
        return unsorted if skip_sort?

        unsorted.each_with_index.sort do |(e1, i1), (e2, i2)|
          cmp = sort_keys
            .map.with_index do |key, idx|
              v1 = e1[key].nil? ? BibTeX::Value.new : e1[key]
              v2 = e2[key].nil? ? BibTeX::Value.new : e2[key]
              if (sort_order[idx] || sort_order.last) =~ /^(desc|reverse)/i
                v2 <=> v1
              else
                v1 <=> v2
              end
            end
            .find { |c| !c.nil? && c != 0 }
          (cmp.nil? || cmp.zero?) ? i1 <=> i2 : cmp
        end.map(&:first)
      end
    end
  end
end

# ---------------------------------------------------------------- (4)
module ScholarExtras
  # Return the raw text of one @entry{key, ...} block from the site's
  # bibliography file (so we can read biblatex fields like author+an that
  # are awkward to reach through bibtex-ruby / Liquid).
  def self.raw_entry(site, key)
    @raw ||= {}
    @raw[site.source] ||= begin
      cfg = site.config['scholar'] || {}
      path = File.join(site.source,
                       (cfg['source'] || './_bibliography').sub(%r{\A\./}, ''),
                       cfg['bibliography'] || 'references.bib')
      File.exist?(path) ? File.read(path) : ''
    end
    m = @raw[site.source].match(/@\w+\{#{Regexp.escape(key.to_s)}\s*,.*?\n\}/m)
    m && m[0]
  end
end

module ScholarExtrasFilters
  YUNTAO_PATTERNS = [
    /\bLi,\s*Yuntao\b/,          # bibtex order, full
    /\bYuntao\s+Li\b/,           # display order, full
    /\bLi,\s*Y\.(?![\w.])/,      # family-first initials (APA-like)
    /\bY\.[\s ]?Li\b/       # initials-first (IEEE-like)
  ].freeze

  # Remove the "[n] " prefix the IEEE CSL style puts in front of each
  # reference (it restarts at [1] for every {% bibliography %} tag);
  # continuous numbering across the groups is drawn with CSS counters.
  # Also render bibtex's "and others" as "et al.", like the CV.
  def scholar_strip_number(input)
    input.to_s
         .sub(/\A(\s*(?:<span[^>]*>)*\s*)\[\d+\](?:\s|\u00A0|&#160;|&nbsp;)*/, '\1')
         .gsub(/,?\s*and others\b/, ' et al.')
  end

  # Bold every rendering of the site owner's name.
  def scholar_bold_author(input)
    s = input.to_s.dup
    YUNTAO_PATTERNS.each do |re|
      s.gsub!(re) { "<strong>#{Regexp.last_match(0)}</strong>" }
    end
    s
  end

  # Superscript-star co-first authors declared via author+an = {N=cofirst;...}
  def scholar_cofirst(input, key)
    s = input.to_s
    site = @context.registers[:site]
    raw = ScholarExtras.raw_entry(site, key)
    return s unless raw

    an = raw[/author\+an\s*=\s*\{([^}]*)\}/, 1]
    return s unless an

    cofirst = an.scan(/(\d+)\s*=\s*cofirst/i).flatten.map { |n| n.to_i - 1 }
    return s if cofirst.empty?

    authors = raw[/^[ \t]*author[ \t]*=[ \t]*\{([^{}]*)\}/, 1].to_s
                .split(/\s+and\s+/).map(&:strip)

    cofirst.each do |i|
      name = authors[i] or next
      family = name.include?(',') ? name.split(',').first.strip : name.split.last
      s = s.sub(/\b#{Regexp.escape(family)}(?=[\s,.:;<])/) do
        "#{Regexp.last_match(0)}<sup>*</sup>"
      end
    end
    s
  end
end

Liquid::Template.register_filter(ScholarExtrasFilters)
