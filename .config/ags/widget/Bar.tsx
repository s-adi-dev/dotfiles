import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import WorkSpaces from "./modules/workspace";
import Wifi from "./modules/wifi";
import Battery from "./modules/battery"; // Import battery module
import Time from "./modules/time";

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      className="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={App}
    >
      <centerbox className="centerbox">
        <WorkSpaces />

        <box />

        <box hexpand halign={Gtk.Align.END}>
          <Wifi />
          <Battery />
          <Time />
        </box>
      </centerbox>
    </window>
  );
}
