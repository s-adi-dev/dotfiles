import { Variable } from "astal";

const time = Variable("").poll(1000, "date '+%H : %M'");

export default function () {
  return <label className="Time" label={time()} />;
}
