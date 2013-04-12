function main
  scene = canvas!

  scene.title.text "Stars in da 'hood\n"

  for name, star of Stars
    star.name = name
    star.center = vec star.position.x, star.position.y, star.position.z
    color = Color star.spectral

    star.sphere = sphere do
      color: color
      pos: star.center
      size: 0.25["*"](vec(1, 1, 1))
      emissive: true
      texture:
        file: 'glow/textures/ven0aaa2.jpg'
        bump: null

    star.light = local_light do
      pos: star.center,
      color: color

    star.label = label do
      pos: star.center
      text: star.name
      box: no
      line: no
      visible: no

    star.label.star = star.sphere.star = star;

  for wormhole in Wormholes
    pos = Stars.(wormhole.0).center
    axis = Stars.(wormhole.1).center.sub Stars.(wormhole.0).center
    length = axis.mag!

    wormhole.conea = cone do
      pos: pos
      axis: axis.norm!
      size: vec length, 0.1, 0.1
      texture:
        file: 'glow/textures/Space_Wormhole.jpg'
        bump: null

    wormhole.coneb = cone do
      pos: pos.add axis
      axis: vec 0, 0, 0 .sub axis.norm!
      size: vec length, 0.1, 0.1
      texture:
        file: 'glow/textures/Space_Wormhole.jpg'
        bump: null

  scene.bind 'click', ->
    hit = scene.mouse.pick!
    if hit?star
      scene.camera.follow hit
      scene.caption.text hit.star.name

$ ->
  window.__context = { glowscript_container: $("\#glowscript").removeAttr("id") };

  $ \#labels .click -> [star.label.visible = !star.label.visible for s, star of Stars]

  main!
