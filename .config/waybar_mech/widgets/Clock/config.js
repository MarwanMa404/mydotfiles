function Test() {
  return Widget.Box({
    children: [
      Widget.Button({
        label: "Hello",
        onClicked: () => test.visible = !test.visible ,
      })
    ],
  })
} 

const test = Widget.Window({
    name: 'window-name',
    anchor: ['top', 'left', 'right'],
    exclusivity: 'normal',
    keymode: 'on-demand',
    layer: 'top',
    visible: true,
    margins: [0, 6],
    monitor: 0,
    child: Widget.Button({
    label: "hello",
    onClicked: () => test.visible = !test.visible,
  }),
})


