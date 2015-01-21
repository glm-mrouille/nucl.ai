---
---

$(window).load ->
  # make background gif animation to referesh each time the page is loaded
  backgroundImage = "{{'/img/audience.gif' | prepend: site.baseurl }}"
  $("<img />").attr('src', backgroundImage).load ->
    #render gif when cached
    $("section.splash-screen").css('background-image', 'url("' + backgroundImage + "?time=" + Date.now() + '")')

$ ->
  $('logo-wrap').addClass("rotated")
  $('logo-wrap').removeClass("opacity0")
  $('titles').removeClass("opacity0")