---
layout: studio
title: "Curriculum Vitae"
permalink: /cv/
redirect_from:
  - /resume
---

{% include base_path %}

<div style="display:flex;justify-content:space-between;align-items:center;margin:0 0 18px;font-size:0.86rem;">
  <a href="{{ base_path }}/">← Back to Home</a>
  <a class="s-btn s-btn--primary" href="{{ base_path }}/files/CV_YuntaoLi.pdf"><i class="fas fa-file-pdf" aria-hidden="true"></i> Download Full CV (PDF)</a>
</div>

<section class="s-sec" style="margin-top:8px;">
  <div class="s-flanked"><h2>Education</h2></div>
  <div class="s-news">
    <div class="s-news__row"><span class="s-news__date">2025–Now</span><span><strong>University of Florida</strong> — Ph.D. in Computer Science · Advisor: Prof. Hoang-Dung Tran</span></div>
    <div class="s-news__row"><span class="s-news__date">2021–2025</span><span><strong>University of Nebraska–Lincoln</strong> — Ph.D. in Computer Science · Advisor: Prof. Hoang-Dung Tran</span></div>
    <div class="s-news__row"><span class="s-news__date">2016–2020</span><span><strong>University of Nebraska at Kearney</strong> — B.S. in Computer Science Comprehensive (<em>Summa Cum Laude</em>) · Advisor: Prof. Sherri K. Weitl-Harms</span></div>
  </div>
</section>

<section class="s-sec">
  <div class="s-flanked"><h2>Research Experience</h2></div>
  <div class="s-news">
    <div class="s-news__row"><span class="s-news__date">2025–Now</span><span><strong>Graduate Research Assistant, University of Florida</strong> — Perception-based runtime verification and world modeling for autonomous vehicles.</span></div>
    <div class="s-news__row"><span class="s-news__date">2021–2025</span><span><strong>Graduate Research Assistant, University of Nebraska–Lincoln</strong> — Verification of deep neural networks, learning-enabled CPS, and ROS-based autonomous systems.</span></div>
    <div class="s-news__row"><span class="s-news__date">2021</span><span><strong>Research Assistant, University of Nebraska at Kearney</strong> — Predicting cyberattacks from social media networks (Advisor: Prof. Md Liaquat Hossain).</span></div>
  </div>
</section>

<section class="s-sec">
  <div class="s-flanked"><h2>Publications</h2></div>
  <div class="s-pub-note-top">&ldquo;*&rdquo; indicates co-first authors</div>
  <div class="s-pub-groups">
    <div class="s-pub-cat">Journal Articles</div>
    {% bibliography --query @*[keywords~=journal] %}
    <div class="s-pub-cat">Conference Papers</div>
    {% bibliography --query @*[keywords~=conference] %}
    {% assign has_sub = 'submitted' | scholar_has_public_entries %}
    {% if has_sub %}
    <div class="s-pub-cat">In Submission</div>
    {% bibliography --query @*[keywords~=submitted] %}
    {% endif %}
  </div>
</section>

<section class="s-sec">
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

<section class="s-sec">
  <div class="s-flanked"><h2>Teaching &amp; Academic Service</h2></div>
  <div class="s-two-col">
    <ul class="s-compact-list">
      <li><strong>Guest Lecturer</strong> — CSCE 322 Programming Language Concepts (UNL, Spring '25); CSCE 460/860 Software Engineering for Robotics (UNL, Fall '24).</li>
      <li><strong>Teaching Assistant (UF)</strong> — COP 5556 Programming Language Principles (Fall '26).</li>
      <li><strong>Teaching Assistant (UNL)</strong> — CSCE 322 (Fall '24, Spring '25); CSCE 460/860 (Spring '23, '24, '25).</li>
      <li><strong>Teaching Assistant (UNK)</strong> — CYBR 407 Intro Automata/Formal Language (Fall '20); CYBR 330 Algorithms &amp; Data Structures (Fall '20); CYBR 103 &amp; CYBR 101 (Spring '20).</li>
      <li><strong>Mentoring</strong> — <em>M.S.:</em> Stuti Ruparel (UF); <em>Undergraduates:</em> Zou Li David, Nathan Chin-Lue, Son Tran, Benjamin Kojusner (UF); <em>REU:</em> Skyloer Cole (Worcester Polytechnic Institute).</li>
    </ul>
    <ul class="s-compact-list">
      <li><strong>Journal Reviewer</strong> — MultiMedia Tools and Applications (2023, 2024); IEEE Design &amp; Test (2023).</li>
      <li><strong>Conference Reviewer / PC</strong> — SAIV 2024, ERAS 2025, L4DC 2025, QEST+FORMATS 2025, L4DC 2026, NeuS 2026, SAIV 2026, CDC 2026, CAV 2026, L4DC 2027.</li>
      <li><strong>Artifact Reviewer</strong> — FormaliSE 2024, QEST+FORMATS 2025, FormaliSE 2026, HSCC/ICCPS 2026, CAV 2026, HSCC/ICCPS 2027.</li>
    </ul>
  </div>
</section>
