import { apiInitializer } from "discourse/lib/api";
import DiscordWidget from "../components/discord-widget";

export default apiInitializer("1.28.0", (api) => {
  // If login is required
  if (settings.require_login && !api.getCurrentUser()) {
    return;
  }

  // If a trust level is required
  if ((api.getCurrentUser()?.trust_level ?? 0) < settings.minimum_trust_level) {
    return;
  }

  // If user must be staff
  if (settings.require_staff && !api.getCurrentUser()?.staff) {
    return;
  }

  // If user must be a group member
  if (settings.required_groups.length > 0) {
    const requiredGroups = settings.required_groups
      .split("|")
      .map((g) => Number(g));

    const currentUserGroups = (api.getCurrentUser()?.groups ?? []).map(
      (g) => g.id
    );

    if (!currentUserGroups.some((g) => requiredGroups.includes(g))) {
      return;
    }
  }

  api.headerIcons.add("discord-widget", DiscordWidget, { before: "search" });
});
