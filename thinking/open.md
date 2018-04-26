---
layout: default
title: Thinking articles tagged in open
---
<body id="thinking">
<div class="page-wrapper">
<!-- Everything after this should be Editable as content -->
<section class="content-12 marg">
  <h1>
    <span class="wide btn-wide btn-wide2" style="background:transparent url(../../images/open-page-header.jpg) center top no-repeat;">Thinking - Articles tagged in Open</span>
  </h1>
</section>

<section class="projects-1 thinking">

	{% include breadcrumbs.html %}

    <div class="container">

		<!-- Tags -->
        <div class="title">
            <a href="{{ "/thinking/announcements" | prepend: site.baseurl }}" >Announcements</a>
            <a href="{{ "/thinking/open" | prepend: site.baseurl }}" class="active">Open</a>
            <a href="{{ "/thinking/privacy" | prepend: site.baseurl }}">Privacy</a>
        </div>

        <!-- Thought Pieces posted within the tag open -->
    {% for post in site.tags.open %}
        {% assign rowindex = forloop.index0 | modulo: 3 %}
        {% if rowindex == 0 or forloop.first %}
          <div class="projects row">
        {% endif %}
            <div class="project-wrapper">
              <div class="project">
                <div class="photo-wrapper">
      <div class="photo">
        <img src="{{ post.image }}" alt="{{ post.title }}"/>
      </div>
      <a href="{{ post.url | prepend: site.baseurl }}">
        <div class="overlay"><span class="fui-eye"></span></div>
      </a>
                </div>
                <div class="info">
      <h4 class="name">
        <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
      </h4>
      <p class="blog-author-date">by {{ post.author }}, {{ post.post_date }}</p>
      <p class="blog-excerpt">{{ post.description | strip_html | truncatewords: 15 }}<br/>
        <span class="blog-meta">posted in
          {% for tag in post.tags %}
            <a href="{{ site.baseurl }}/thinking/tag/{{ tag }}">{{ tag }}</a>{% unless forloop.last %}, {% endunless %}
          {% endfor %}
        </span>
      </p>
                </div>
              </div>
      </div>
    {% if rowindex == 2 or forloop.last %}
    </div> <!-- projects row -->
    <div class="clearfix"></div>
  	{% endif %}
        {% endfor %}



    </div>
    <!--/.container-->
</section>

</body >
