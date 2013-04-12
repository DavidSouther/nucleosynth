function main
  scene = canvas!
  scene.title.text "Stars in da 'hood\n"
  $("<div id='fps'/>").appendTo scene.title

  for star in Stars
    star.center = vec star.position.x, star.position.y, star.position.z
    star.color = Color star.spectral
    star.sphere = sphere do
      color: star.color
      pos: star.center
      size: 0.25["*"](vec(1, 1, 1))
      emissive: true

    star.light = local_light do
      pos: star.center,
      color: star.color

    star.sphere.star = star;

  scene.bind 'click', ->
    hit = scene.mouse.pick!
    if hit?star
      scene.camera.follow hit
      scene.caption.text hit.star.name

$ ->
  window.__context = { glowscript_container: $("\#glowscript").removeAttr("id") };

  main!
