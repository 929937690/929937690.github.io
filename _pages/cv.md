---
layout: archive
title: "CV"
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}

<p>
  <a href="{{ base_path }}/files/CV_YuntaoLi.pdf" class="btn btn--primary"><i class="fas fa-download" aria-hidden="true"></i> Download CV (PDF)</a>
</p>

Education
======
* **Ph.D. in Computer Science**, University of Florida, Aug. 2025 – Present.
  * Advisor: Prof. Hoang-Dung Tran.
* **Ph.D. in Computer Science**, University of Nebraska - Lincoln, Aug. 2021 – Aug. 2025.
  * Advisor: Prof. Hoang-Dung Tran.
* **B.S. in Computer Science Comprehensive**, University of Nebraska at Kearney, Aug. 2016 – Dec. 2020. Summa Cum Laude.
  * Advisor: Prof. Sherri K. Weitl-Harms.

Research Experience
======
* **Graduate Research Assistant**, University of Florida, Aug. 2025 – Present.
  * Advisor: Prof. Hoang-Dung Tran.
  * Perception-based runtime verification and world modeling for autonomous vehicles.
* **Graduate Research Assistant**, University of Nebraska - Lincoln, Aug. 2021 – Aug. 2025.
  * Advisor: Prof. Hoang-Dung Tran.
  * Verification of deep neural networks and learning-enabled CPS; formal techniques for modeling, recognizing, localizing, and mitigating cyberattacks in ROS-based autonomous systems.
* **Research Assistant**, University of Nebraska at Kearney, Feb. 2021 – Aug. 2021.
  * Advisor: Prof. Md Liaquat Hossain.
  * Predicting cyber attacks from social media networks.

Publications
======
<p class="pub-legend"><em>&quot;*&quot; indicates co-first authors</em></p>

<div class="pub-groups">
{% bibliography %}
</div>

Teaching & Mentoring
======
* **Guest Lecturer**: CSCE322 Programming Language Concepts (UNL, Spring 2025); CSCE460/860 Software Engineering for Robotics (UNL, Fall 2024).
* **Teaching Assistant**: CSCE322 Programming Language Concepts (UNL, Fall 2024, Spring 2025); CSCE460/860 Software Engineering for Robotics (UNL, Spring 2023, 2024, 2025); CYBR407 Intro Automata/Formal Language (UNK, Fall 2020); CYBR330 Algorithms and Data Structure (UNK, Fall 2020); CYBR103 Introduction to Programming Language (UNK, Spring 2020); CYBR101 Python for Analytics (UNK, Spring 2020).
* **Mentoring**: REU student Skyloer Cole (Worcester Polytechnic Institute).

Academic Service
======
* **Journal Reviewer**: MultiMedia Tools and Applications (2023, 2024); IEEE Design & Test (2023).
* **Conference Reviewer / PC Member**: SAIV 2024, ERAS 2025, L4DC 2025, QEST+FORMATS 2025, L4DC 2026.
* **Artifact Reviewer**: Formalise 2024, QEST+FORMATS 2025, FormaliSE 2026, HSCC/ICCPS 2026, CAV 2026.

Honors & Awards
======
* CBT Outstanding Junior Scholarship ($500), 2020–2021.
* UNK College of Business Scholarship ($500), 2020–2021.

Software Tools
======
* [StarV](https://github.com/V2A2/StarV) — A Qualitative and Quantitative Verification Tool for Learning-enabled Systems (main developer).
* [NNV](https://github.com/verivital/nnv) — Verification of Deep Neural Networks and Learning-enabled Autonomous CPS (contributor).

<style>
  /* Continuous [1]..[n] numbering for the bibliography (CV convention). */
  .pub-groups { counter-reset: pubn; }
  .pub-groups ol.bibliography { list-style: none; margin: 0 0 1.6em; padding-left: 0; }
  .pub-groups ol.bibliography > li {
    counter-increment: pubn;
    position: relative;
    padding-left: 2.8em;
    margin-bottom: 0.9em;
  }
  .pub-groups ol.bibliography > li::before {
    content: "[" counter(pubn) "]";
    position: absolute;
    left: 0;
    color: #494e52;
  }
  .pub-legend { margin-bottom: 0.5em; }
  .pub-note { font-style: italic; }
</style>
