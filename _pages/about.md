---
layout: studio
permalink: /
title: "Yuntao Li"
redirect_from:
  - /about/
  - /about.html
---

{% include base_path %}

<section class="s-hero">
  <div>
    <div class="s-eyebrow">CISE · University of Florida</div>
    <h1 class="s-name">Yuntao Li</h1>
    <p class="s-affil">Ph.D. Student in Computer Science · TransSafeAI Research Group</p>
    <div class="s-bio">
      <p>I am a Ph.D. student in Computer &amp; Information Science &amp; Engineering at the <strong>University of Florida</strong>, working as a Graduate Research Assistant in the <a href="https://sites.google.com/view/v2a2/about">TransSafeAI research group</a> advised by Prof. Hoang-Dung Tran.</p>
      <p>My research develops formal verification and runtime assurance methods for <strong>learning-enabled cyber-physical systems</strong> and <strong>safe, trustworthy artificial intelligence</strong> — spanning Star and ProbStar reachability for deep neural networks, recurrent architectures, semantic segmentation, and autonomous robotics. Previously, I began my Ph.D. at the University of Nebraska–Lincoln (2021–2025) and earned my B.S. in Computer Science (<em>Summa Cum Laude</em>) from the University of Nebraska at Kearney.</p>
    </div>
    <div class="s-tags">
      <span class="s-tag">Neural Network Verification</span>
      <span class="s-tag">ProbStar Reachability</span>
      <span class="s-tag">Runtime Monitoring</span>
      <span class="s-tag">Safe Autonomous CPS</span>
    </div>
    <div class="s-actions">
      <a class="s-btn s-btn--primary" href="{{ base_path }}/files/CV_YuntaoLi.pdf"><i class="fas fa-file-pdf" aria-hidden="true"></i> Curriculum Vitae</a>
      <a class="s-btn" href="mailto:yli17@ufl.edu"><i class="fas fa-envelope" aria-hidden="true"></i> Email</a>
      <a class="s-btn" href="https://scholar.google.com/citations?user=_RzS3uMAAAAJ&hl=en"><i class="ai ai-google-scholar" aria-hidden="true"></i> Scholar</a>
      <a class="s-btn" href="https://github.com/929937690"><i class="fab fa-github" aria-hidden="true"></i> GitHub</a>
      <a class="s-btn" href="https://www.linkedin.com/in/yuntaoliy3"><i class="fab fa-linkedin" aria-hidden="true"></i> LinkedIn</a>
    </div>
  </div>
  <div>
    <img class="s-portrait" src="{{ base_path }}/images/profile.jpg" alt="Yuntao Li" fetchpriority="high">
  </div>
</section>

<section class="s-sec" id="news">
  <div class="s-flanked"><h2>Recent News</h2></div>
  <div class="s-news">
    <div class="s-news__row"><span class="s-news__date">2026</span><span>Three papers on RNN, semantic segmentation, and SparseImageStar CNN verification submitted to <strong>ATVA 2026</strong>.</span></div>
    <div class="s-news__row"><span class="s-news__date">Aug 2025</span><span>Moved with the TransSafeAI group to the <strong>University of Florida</strong> (CISE) to continue my Ph.D. with Prof. Hoang-Dung Tran.</span></div>
    <div class="s-news__row"><span class="s-news__date">Jul 2025</span><span><strong>StarV</strong> verification tool paper presented at <strong>CAV 2025</strong> (co-first author).</span></div>
    <div class="s-news__row"><span class="s-news__date">May 2025</span><span>ProbStar Temporal Logic paper presented at <strong>HSCC 2025</strong>; two journal articles published in <em>Nonlinear Analysis: Hybrid Systems (NAHS)</em>.</span></div>
    <div class="s-news__row"><span class="s-news__date">2024</span><span>Paper on perception-based runtime monitoring accepted at <strong>MEMOCODE 2024</strong>.</span></div>
  </div>
</section>

<section class="s-sec" id="publications">
  <div class="s-flanked"><h2>Publications</h2></div>
  <div class="s-pub-note-top">&ldquo;*&rdquo; indicates co-first authors · <a href="https://scholar.google.com/citations?user=_RzS3uMAAAAJ&hl=en">Google Scholar ↗</a></div>

  <div class="s-pub-groups">
    <div class="s-pub-cat">Journal Articles</div>
    {% bibliography --query @*[keywords~=journal] %}

    <div class="s-pub-cat">Conference Papers</div>
    {% bibliography --query @*[keywords~=conference] %}

    <div class="s-pub-cat">In Submission</div>
    {% bibliography --query @*[keywords~=submitted] %}
  </div>
</section>

<section class="s-sec" id="software">
  <div class="s-flanked"><h2>Open-Source Tools</h2></div>
  <div class="s-bento">
    <div class="s-card">
      <div class="s-card__top">
        <a class="s-card__name" href="https://github.com/V2A2/StarV">StarV ↗</a>
        <span class="s-card__tag">Main Developer · CAV '25</span>
      </div>
      <p>Qualitative and quantitative verification framework for learning-enabled systems using Star and ProbStar reachability.</p>
    </div>
    <div class="s-card">
      <div class="s-card__top">
        <a class="s-card__name" href="https://github.com/verivital/nnv">NNV ↗</a>
        <span class="s-card__tag">Contributor</span>
      </div>
      <p>Set-based verification toolbox for deep neural networks and learning-enabled autonomous cyber-physical systems.</p>
    </div>
  </div>
</section>

<section class="s-sec" id="teaching">
  <div class="s-flanked"><h2>Teaching &amp; Academic Service</h2></div>
  <div class="s-two-col">
    <ul class="s-compact-list">
      <li><strong>Guest Lecturer</strong> — CSCE 322 Programming Language Concepts (UNL, Spring '25); CSCE 460/860 Software Engineering for Robotics (UNL, Fall '24).</li>
      <li><strong>Teaching Assistant (UNL)</strong> — CSCE 322 (Fall '24, Spring '25); CSCE 460/860 (Spring '23, '24, '25).</li>
      <li><strong>Teaching Assistant (UNK)</strong> — CYBR 407 Intro Automata/Formal Language (Fall '20); CYBR 330 Algorithms &amp; Data Structures (Fall '20); CYBR 103 &amp; CYBR 101 (Spring '20).</li>
      <li><strong>Mentoring</strong> — Skyloer Cole, NSF REU student (Worcester Polytechnic Institute).</li>
    </ul>
    <ul class="s-compact-list">
      <li><strong>Journal Reviewer</strong> — MultiMedia Tools and Applications (2023, 2024); IEEE Design &amp; Test (2023).</li>
      <li><strong>Conference Reviewer / PC</strong> — SAIV 2024, ERAS 2025, L4DC 2025, QEST+FORMATS 2025, L4DC 2026.</li>
      <li><strong>Artifact Reviewer</strong> — FormaliSE 2024, QEST+FORMATS 2025, FormaliSE 2026, HSCC/ICCPS 2026, CAV 2026.</li>
    </ul>
  </div>
</section>
