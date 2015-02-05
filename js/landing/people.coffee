---
---

$ ->
  ## if section isn't included - don't bother
  if $("section.people").length == 0 then return

  ## draw line between selected thumbnail and text
  paper = Raphael('section-people', "100%", "100%") # draw within the whole section

  clearLine = () ->
    $("section.people svg path").remove()

  drawLine = () ->
    thumbnail = $("section.people thumbnail.selected")
    if thumbnail.length == 0 then return
    title = $("item.description[name='" + thumbnail.attr('name') + "'] .thumbnail-title")

    startY = thumbnail.offset().top - $("section.people").offset().top + thumbnail.height()
    startX = thumbnail.offset().left + thumbnail.width() / 2

    #check if line intersects title
    if thumbnail.hasClass("left") and title.offset().left <= startX then return
    if thumbnail.hasClass("right") and title.offset().left >= startX then return

    #calculate vertical line
    endY = title.offset().top + title.outerHeight() - $("section.people").offset().top
    
    # preserve original values
    originalEndY = endY

    # calculate horizontal leftLine
    if thumbnail.hasClass("left") then endX = title.offset().left + title.width()
    if thumbnail.hasClass("right") then endX = title.offset().left
    if thumbnail.hasClass("middle") then endY = endY - title.outerHeight()

    line = paper.path("M" + startX + " " + startY + "L " + startX + " " + endY + " L " + endX + " " + endY)

    if thumbnail.hasClass("middle")
      #draw disconnected horizontal line
      paper.path("M " + title.offset().left + " " + originalEndY + "L " + (title.offset().left + title.width()) + " " + originalEndY)

  drawLine()

  setThumbnailSize = () ->
    $("section.people thumbnail-wrap").each ->
      wrap = $(this)
      wrap.height(wrap.width())


  setThumbnailSize()
  ## listen when window resizes to clear lines and redrew them once finished
  resizeEnd = null
  $(window).resize ->
    clearLine()
    setThumbnailSize()
    drawLine()


  ## hide/show overlay on animation start/end
  selected = null
  selectedTxt = null
  selectedTitle = null

  $("section.people thumbnail").each ->
    thumbnail = $(this)
    if thumbnail.hasClass("selected")
      # discover selected by default
      selected = thumbnail
      selectedTxt = $(".description[name='" + selected.attr('name') + "']")
      selectedTitle = $("item.thumbnail .thumbnail-title[name='" + selected.attr('name') + "']")


    ## change title color on thumbnail hover
    mouseEnter = () ->
      $("item.thumbnail .thumbnail-title[name='" + thumbnail.attr('name') + "']").addClass("hover")
    mouseLeave = () ->
      $("item.thumbnail .thumbnail-title[name='" + thumbnail.attr('name') + "']").removeClass("hover")

    thumbnail.hover mouseEnter, mouseLeave


    thumbnail.click ->
      thumbnail.toggleClass("selected")
      $(".description[name='" + thumbnail.attr('name') + "']").toggleClass("selected")
      $("item.thumbnail .thumbnail-title[name='" + thumbnail.attr('name') + "']").toggleClass("selected")
      if thumbnail != selected
        if selected != null
          selected.toggleClass("selected")
          selectedTxt.toggleClass("selected")
          selectedTitle.toggleClass("selected")
        selected = thumbnail
        selectedTxt = $(".description[name='" + selected.attr('name') + "']")
        selectedTitle = $("item.thumbnail .thumbnail-title[name='" + selected.attr('name') + "']")
      else 
        selected = null
        selectedTitle - null
        selectedTxt = null
      clearLine()
      drawLine()
