# frozen_string_literal: true
#
# Site-local extensions for jekyll-scholar:
#   1. Ruby 3.x / 3.4 compatibility patches for bibtex-ruby 4.4.7.
#   2. Strip inline "% ..." comments inside entries so _bibliography/publications.bib
#      remains byte-identical to canonical cv-yuntaoli/publications.bib.
#   3. Stable sort falling back to .bib file order on ties.
#   4. Structured publication card filters (venue badge, bolded author + co-first *,
#      venue/note formatting, and clean BibTeX snippet).

require 'bibtex'
require 'cgi'

module BibTeX
  class Bibliography
    def each(&block)
      block ? (data.each(&block); self) : to_enum
    end

    def each_entry(&block)
      block ? q('@entry').each(&block) : q('@entry').to_enum
    end
  end

  class Entry
    def each(&block)
      block ? (fields.each(&block); self) : to_enum
    end
    alias each_pair each

    def convert(*filters, &block)
      block ? dup.convert!(*filters, &block) : dup.convert!(*filters)
    end

    alias_method :to_citeproc_without_venue_fix, :to_citeproc
    def to_citeproc(options = {})
      hash = to_citeproc_without_venue_fix(options)
      if hash['type'] == 'paper-conference' && hash['container-title']
        hash['type'] = 'chapter'
      end
      hash
    end
  end

  class Name
    def dup
      self.class.new(Hash[each_pair.to_a])
    end
  end
end

module Jekyll
  class Scholar
    module Utilities
      def bibliography
        unless @bibliography
          raw = bibtex_paths.reduce(+'') { |s, p| s << IO.read(p) }
          raw = raw.gsub(/@\w+\{[^@]*?\n\}\s*/m) do |blk|
            blk =~ /keywords\s*=\s*\{[^}]*\bblind\b[^}]*\}/i ? '' : blk
          end
          raw = raw.gsub(/^(.*\},?)[ \t]+%[^\n]*$/, '\1')
          @bibliography = BibTeX::Bibliography.parse(raw, bibtex_options)
          @bibliography.replace_strings if replace_strings?
          @bibliography.join if join_strings? && replace_strings?
        end
        @bibliography
      end

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

module ScholarExtras
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

  def self.field(raw, name)
    return nil unless raw

    m = raw.match(/^[ \t]*#{Regexp.escape(name)}[ \t]*=[ \t]*\{/i)
    return nil unless m

    pos = m.end(0)
    depth = 1
    while pos < raw.length && depth.positive?
      case raw[pos]
      when '{' then depth += 1
      when '}' then depth -= 1
      end
      pos += 1
    end
    return nil unless depth.zero?

    raw[m.end(0)...(pos - 1)].gsub(/[{}]/, '').strip
  end

  def self.format_authors(raw)
    return '' unless raw

    an = field(raw, 'author+an').to_s
    cofirst = an.scan(/(\d+)\s*=\s*cofirst/i).flatten.map { |n| n.to_i - 1 }
    authors = field(raw, 'author').to_s
                .split(/\s+and\s+/).map(&:strip)

    parts = authors.each_with_index.map do |name, idx|
      next 'et al.' if name.casecmp('others').zero?

      if name.include?(',')
        family, given = name.split(',', 2).map(&:strip)
      else
        tokens = name.split
        family = tokens.pop
        given = tokens.join(' ')
      end
      inits = given.to_s.split(/(\s+|-)/).map do |tok|
        tok =~ /\A[A-Za-z]/ ? "#{tok[0]}." : tok
      end.join.gsub(/\.\./, '.')
      disp = "#{inits} #{family}".squeeze(' ').strip
      star = cofirst.include?(idx) ? '<sup>*</sup>' : ''
      if family == 'Li' && given.to_s.start_with?('Y')
        "<strong>#{CGI.escapeHTML(disp)}</strong>#{star}"
      else
        "#{CGI.escapeHTML(disp)}#{star}"
      end
    end
    parts.join(', ').gsub(', et al.', ' et al.')
  end
end

module ScholarExtrasFilters
  def scholar_venue_badge(key)
    site = @context.registers[:site]
    raw = ScholarExtras.raw_entry(site, key)
    return '' unless raw

    kw = ScholarExtras.field(raw, 'keywords').to_s
    yr = ScholarExtras.field(raw, 'year').to_s
    venue_src = (ScholarExtras.field(raw, 'journal') ||
                 ScholarExtras.field(raw, 'booktitle') ||
                 ScholarExtras.field(raw, 'note')).to_s
    acr = venue_src[/\(([A-Z0-9+\-\s]{2,14})\)/, 1]
    short_yr = yr.length == 4 ? "'#{yr[2..3]}" : yr

    kind = if kw.include?('journal')
             'journal'
           elsif kw.include?('submitted') || ScholarExtras.field(raw, 'note').to_s =~ /\ASubmitted/i
             'submitted'
           else
             'conference'
           end

    label = acr ? "#{acr} #{short_yr}" : yr
    return '' if label.empty?

    %(<span class="s-badge s-badge--#{kind}">#{CGI.escapeHTML(label)}</span>)
  end

  def scholar_card_authors(key)
    site = @context.registers[:site]
    ScholarExtras.format_authors(ScholarExtras.raw_entry(site, key))
  end

  def scholar_card_venue(key)
    site = @context.registers[:site]
    raw = ScholarExtras.raw_entry(site, key)
    return '' unless raw

    yr = ScholarExtras.field(raw, 'year').to_s
    journal = ScholarExtras.field(raw, 'journal')
    booktitle = ScholarExtras.field(raw, 'booktitle')
    note = ScholarExtras.field(raw, 'note')

    parts = []
    parts << "<em>#{CGI.escapeHTML(journal || booktitle)}</em>" if journal || booktitle
    parts << "<em>#{CGI.escapeHTML(note)}</em>" if note
    parts << CGI.escapeHTML(yr) unless yr.empty?
    parts.join(', ')
  end

  def scholar_clean_bibtex(key)
    site = @context.registers[:site]
    raw = ScholarExtras.raw_entry(site, key)
    return '' unless raw

    cleaned = raw.lines.reject { |ln| ln =~ /^\s*(presort|keywords|author\+an|pdf)\s*=/ }
                 .map { |ln| ln.sub(/^(.*\},?)[ \t]+%.*$/, '\1') }.join
    CGI.escapeHTML(cleaned.strip)
  end

  def scholar_paper_pdf(key)
    site = @context.registers[:site]
    local_rel = "/files/papers/#{key}.pdf"
    return local_rel if File.exist?(File.join(site.source, local_rel))

    raw = ScholarExtras.raw_entry(site, key)
    ext = ScholarExtras.field(raw, 'pdf')
    ext && !ext.empty? ? ext : ''
  end

  def scholar_is_flagship(key)
    %w[tran2025starv li2026quantitative li2025quantitative].include?(key.to_s)
  end

  def scholar_has_public_entries(keyword)
    site = @context.registers[:site]
    cfg = site.config['scholar'] || {}
    path = File.join(site.source,
                     (cfg['source'] || './_bibliography').sub(%r{\A\./}, ''),
                     cfg['bibliography'] || 'references.bib')
    return false unless File.exist?(path)

    File.read(path).scan(/@\w+\{[^@]*?\n\}/m).any? do |blk|
      kw = ScholarExtras.field(blk, 'keywords').to_s
      kw.include?(keyword.to_s) && kw !~ /\bblind\b/i
    end
  end
end

Liquid::Template.register_filter(ScholarExtrasFilters)
