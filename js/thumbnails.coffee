---
---

root = exports ? this # global


class Thumbnails

  constructor: (sectionId) ->
    that = @
    @section  = $("#" + sectionId)
    if @section.length != 1 
        console.warn "Can't discover section #{section_selector}"
        return
    ## buid svg
    @paper = Raphael(sectionId, "100%", "100%")
    ## select jquery object
    @svg = @section.find("svg")
    @wraps =  @section.find("thumbnail-wrap")
    @thumbnails = @section.find("thumbnail")

    $(window).resize ->
      that.clearLine()
      that.setThumbnailSize()
      that.drawLine()

    @thumbnails.each ->
      @.jQthumbnail = $(@)
      @.jQdescription = $(".description[name='" + $(@).attr('name') + "']")
      @.jQtitle = $("item.thumbnail .thumbnail-title[name='" + $(@).attr('name') + "']")
      
      ## change title color on thumbnail hover
      t = @
      t.jQthumbnail.hover () ->
          t.jQtitle.addClass("hover")
        ,
        () ->
          t.jQtitle.removeClass("hover")

    @selected = @thumbnails.filter(".selected")
    @thumbnails.each ->
      t = @ 
      t.jQthumbnail.click ->
        t.jQthumbnail.toggleClass("selected")
        t.jQdescription.toggleClass("selected")
        t.jQtitle.toggleClass("selected")
        if t != that.selected
          if that.selected.length != 0
            that.selected.jQthumbnail.toggleClass("selected")
            that.selected.jQdescription.toggleClass("selected")
            that.selected.jQtitle.toggleClass("selected")
          that.selected = t
        else 
          that.selected = []
        that.clearLine()
        that.drawLine()

     @setThumbnailSize()

  ## drawing svg

  setThumbnailSize: ->
    @wraps.each ->
      wrap = $(this)
      wrap.height(wrap.width())

  clearLine: ->
    @svg.find("path").remove()

  drawLine: ->
    thumbnail = @thumbnails.filter(".selected")
    if thumbnail.length == 0 then return

    title = thumbnail[0].jQdescription.find(".thumbnail-title")
    thumbnail = thumbnail[0].jQthumbnail

    startY = thumbnail.offset().top - @section.offset().top + thumbnail.height()
    startX = thumbnail.offset().left + thumbnail.width() / 2

    #check if line intersects title
    if thumbnail.hasClass("left") and title.offset().left <= startX then return
    if thumbnail.hasClass("right") and title.offset().left >= startX then return

    #calculate vertical line
    endY = title.offset().top + title.outerHeight() - @section.offset().top
    
    # preserve original values
    originalEndY = endY

    # calculate horizontal leftLine
    if thumbnail.hasClass("left") then endX = title.offset().left + title.width()
    if thumbnail.hasClass("right") then endX = title.offset().left
    if thumbnail.hasClass("middle") then endY = endY - title.outerHeight()

    line = @paper.path("M" + startX + " " + startY + "L " + startX + " " + endY + " L " + endX + " " + endY)

    if thumbnail.hasClass("middle")
      #draw disconnected horizontal line
      @paper.path("M " + title.offset().left + " " + originalEndY + "L " + (title.offset().left + title.width()) + " " + originalEndY)



root.Thumbnails = Thumbnails