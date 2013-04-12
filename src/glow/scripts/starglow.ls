function main
  scene = canvas!
  scene.title.text "Stars in da 'hood\n"

  for name, star of Stars
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

  for wormhole in Wormholes
    pos = Stars.(wormhole.0).center
    axis = Stars.(wormhole.1).center.sub Stars.(wormhole.0).center
    length = axis.mag!
    wormhole.cylinder = cylinder do
      pos: pos
      axis: axis.norm!
      size: vec length, 0.1, 0.1

  scene.bind 'click', ->
    hit = scene.mouse.pick!
    if hit?star
      scene.camera.follow hit
      scene.caption.text hit.star.name

$ ->
  window.__context = { glowscript_container: $("\#glowscript").removeAttr("id") };

  main!
