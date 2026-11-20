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
    <div class="s-pub-cat">In Submission</div>
    {% bibliography --query @*[keywords~=submitted] %}
  </div>
</section>
