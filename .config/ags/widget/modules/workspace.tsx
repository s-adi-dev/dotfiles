import { bind } from "astal";
import Hyprland from "gi://AstalHyprland";

function groupByProperty(array: Hyprland.Workspace[]): Hyprland.Workspace[][] {
  const map = new Map<Hyprland.Monitor, Hyprland.Workspace[]>();
  array.forEach((item) => {
    const key = item.monitor;
    if (key === null) {
      return;
    }
    if (!map.has(key)) {
      map.set(key, []);
    }
    map.get(key)!.unshift(item);
  });
  return Array.from(map.values()).sort((a, b) => {
    return a[0].monitor.id - b[0].monitor.id;
  });
}

export default function Workspaces() {
  const hypr = Hyprland.get_default();
  const MIN_WORKSPACES = 4; // Minimum number of workspaces to display

  return (
    <box className="Workspaces">
      {bind(hypr, "workspaces").as((workspaces) => {
        const groupedWorkspaces = groupByProperty(workspaces);
        return groupedWorkspaces.map((workspaceGroup, index) => {
          // Get all workspace IDs for this monitor
          const existingWorkspaceIds = workspaceGroup.map((ws) => ws.id);

          // Create the complete list of workspace IDs to display
          const workspaceIdsToShow = [
            ...Array.from({ length: MIN_WORKSPACES }, (_, i) => i + 1),
            ...existingWorkspaceIds.filter((id) => id > MIN_WORKSPACES),
          ].sort((a, b) => a - b);

          // Remove duplicates
          const uniqueWorkspaceIds = [...new Set(workspaceIdsToShow)];

          return (
            <box className="monitor-group">
              {uniqueWorkspaceIds.map((wsId) => {
                // Find if workspace with this ID exists for this monitor
                const existingWorkspace = workspaceGroup.find(
                  (ws) => ws.id === wsId,
                );
                const isPlaceholder = !existingWorkspace;

                return (
                  <button
                    label={bind(
                      workspaceGroup[0]?.monitor || {},
                      "activeWorkspace",
                    ).as((activeWorkspace) =>
                      activeWorkspace?.id === wsId ? "" : "",
                    )}
                    className={bind(
                      workspaceGroup[0]?.monitor || {},
                      "activeWorkspace",
                    ).as((activeWorkspace) => {
                      // Build className based on workspace state
                      let classes = [];

                      if (isPlaceholder) classes.push("workspace-placeholder");
                      else classes.push("workspace-active");

                      if (activeWorkspace?.id === wsId)
                        classes.push("workspace-focused");

                      return classes.join(" ");
                    })}
                    onClicked={() => {
                      print(wsId);
                      hypr.dispatch("workspace", `${wsId}`);
                    }}
                  ></button>
                );
              })}
            </box>
          );
        });
      })}
    </box>
  );
}
