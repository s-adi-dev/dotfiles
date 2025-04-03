import { Variable } from "astal";
import Battery from "gi://AstalBattery";
import { bind } from "astal";

type BatteryIconKeys = 0 | 10 | 20 | 30 | 40 | 50 | 60 | 70 | 80 | 90 | 100;

type BatteryIcons = {
  [key in BatteryIconKeys]: string;
};

const batteryPercentage = Variable(
  Math.round(Battery.get_default().percentage * 100).toString(),
).poll(1000, () => {
  return Math.round(Battery.get_default().percentage * 100).toString();
});

const batteryIcon = Variable("1").poll(10000, () => {
  const bat = Battery.get_default();
  const batteryLevel = (Math.floor((bat.percentage * 100) / 10) *
    10) as BatteryIconKeys;

  const batteryIcons: BatteryIcons = {
    0: "󰂎 ",
    10: "󰁺 ",
    20: "󰁻 ",
    30: "󰁼 ",
    40: "󰁽 ",
    50: "󰁾 ",
    60: "󰁿 ",
    70: "󰂀 ",
    80: "󰂁 ",
    90: "󰂂 ",
    100: "󰁹 ",
  };

  const batteryIconsCharging: BatteryIcons = {
    0: "󰢟 ",
    10: "󰢜 ",
    20: "󰂆 ",
    30: "󰂇 ",
    40: "󰂈 ",
    50: "󰢝 ",
    60: "󰂉 ",
    70: "󰢞 ",
    80: "󰂊 ",
    90: "󰂋 ",
    100: "󰂅",
  };

  return bat.charging
    ? batteryIconsCharging[batteryLevel]
    : batteryIcons[batteryLevel];
});

export default function BatteryModule() {
  return (
    <label
      className="Battery"
      label={batteryIcon()}
      tooltipText={batteryPercentage()}
    />
  );
}
