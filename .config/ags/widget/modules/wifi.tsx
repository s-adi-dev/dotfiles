import { bind, Variable } from "astal";
import AstalNetwork from "gi://AstalNetwork";

export function getNetworkIconBinding() {
  const network = AstalNetwork.get_default();

  return Variable.derive([
    bind(network, "connectivity"),
    bind(network, "wifi"),
    bind(network, "wired"),
    bind(network, "primary"),
  ])(() => getNetworkIcon(network));
}

export function getNetworkIcon(network: AstalNetwork.Network) {
  const { connectivity, wifi, wired, primary } = network;

  // Handle Wi-Fi connection first (prioritize WiFi over wired)
  if (wifi !== null && primary === AstalNetwork.Primary.WIFI) {
    const { strength, internet, enabled } = wifi;

    // If Wi-Fi is disabled or there is no connectivity
    if (!enabled || connectivity === AstalNetwork.Connectivity.NONE) {
      return "󰤭 ";
    }

    // Based on Wi-Fi signal strength and internet status
    if (strength <= 25) {
      if (internet === AstalNetwork.Internet.DISCONNECTED) {
        return "󰤠 ";
      } else if (internet === AstalNetwork.Internet.CONNECTED) {
        return "󰤟 ";
      } else if (internet === AstalNetwork.Internet.CONNECTING) {
        return "󰤡 ";
      }
    } else if (strength <= 50) {
      if (internet === AstalNetwork.Internet.DISCONNECTED) {
        return "󰤣 ";
      } else if (internet === AstalNetwork.Internet.CONNECTED) {
        return "󰤢 ";
      } else if (internet === AstalNetwork.Internet.CONNECTING) {
        return "󰤤 ";
      }
    } else if (strength <= 75) {
      if (internet === AstalNetwork.Internet.DISCONNECTED) {
        return "󰤦 ";
      } else if (internet === AstalNetwork.Internet.CONNECTED) {
        return "󰤥 ";
      } else if (internet === AstalNetwork.Internet.CONNECTING) {
        return "󰤧 ";
      }
    } else {
      if (internet === AstalNetwork.Internet.DISCONNECTED) {
        return "󰤩 ";
      } else if (internet === AstalNetwork.Internet.CONNECTED) {
        return "󰤨 ";
      } else if (internet === AstalNetwork.Internet.CONNECTING) {
        return "󰤪 ";
      }
    }

    // Fallback if none of the conditions are met
    return "󰤯 ";
  }

  // Handle wired connection (only show if WiFi is not primary)
  else if (wired !== null && primary === AstalNetwork.Primary.WIRED) {
    if (wired.internet === AstalNetwork.Internet.CONNECTED) {
      return "󰈀 ";
    } else {
      return "󰈀 "; // You could add more logic here for wired states if needed
    }
  }

  // If no explicit primary is set but WiFi is available, show WiFi
  else if (wifi !== null) {
    const { strength, internet, enabled } = wifi;

    if (!enabled) return "󰤭 ";

    if (strength <= 25) {
      return internet === AstalNetwork.Internet.CONNECTED ? "󰤟 " : "󰤠 ";
    } else if (strength <= 50) {
      return internet === AstalNetwork.Internet.CONNECTED ? "󰤢 " : "󰤣 ";
    } else if (strength <= 75) {
      return internet === AstalNetwork.Internet.CONNECTED ? "󰤥 " : "󰤦 ";
    } else {
      return internet === AstalNetwork.Internet.CONNECTED ? "󰤨 " : "󰤩 ";
    }
  }

  // Default or unknown status
  return "󰤮 ";
}

export function getAccessPointIcon(accessPoint: AstalNetwork.AccessPoint) {
  const { strength, flags } = accessPoint;

  // Based on Wi-Fi signal strength and internet status
  if (strength <= 25) {
    if (flags === 0) {
      return "󰤟 ";
    } else {
      return "󰤡 ";
    }
  } else if (strength <= 50) {
    if (flags === 0) {
      return "󰤢 ";
    } else {
      return "󰤤 ";
    }
  } else if (strength <= 75) {
    if (flags === 0) {
      return "󰤥 ";
    } else {
      return "󰤧 ";
    }
  } else {
    if (flags === 0) {
      return "󰤨 ";
    } else {
      return "󰤪 ";
    }
  }
}

export default function Wifi() {
  return <label className="Network" label={getNetworkIconBinding()} />;
}
