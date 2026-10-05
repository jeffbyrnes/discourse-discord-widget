import Component from "@glimmer/component";
import { action } from "@ember/object";
import { on } from "@ember/modifier";
import { service } from "@ember/service";
import icon from "discourse/helpers/d-icon";
import DiscourseURL from "discourse/lib/url";
import { i18n } from "discourse-i18n";
import DMenu from "float-kit/components/d-menu";
import getTheme from "../lib/theme";

export default class DiscordWidget extends Component {
  @service site;

  get serverId() {
    return settings.discord_server_id;
  }

  get inviteUrl() {
    return settings.discord_invite_url;
  }

  get src() {
    return `https://discordapp.com/widget?id=${this.serverId}&theme=${getTheme()}`;
  }

  get title() {
    return i18n(themePrefix("discord_widget.title"));
  }

  get warningKey() {
    if (!this.serverId) {
      return "discord_widget.no_server_id";
    }
    if (this.site.mobileView && !this.inviteUrl) {
      return "discord_widget.no_invite_url";
    }
  }

  get warning() {
    return this.warningKey && i18n(themePrefix(this.warningKey));
  }

  // On mobile, with everything configured, skip the panel and open the invite
  get opensInvite() {
    return this.site.mobileView && this.serverId && this.inviteUrl;
  }

  @action
  openInvite() {
    DiscourseURL.routeTo(this.inviteUrl);
  }

  <template>
    <li class="header-dropdown-toggle discord-widget-toggle">
      {{#if this.opensInvite}}
        <button
          type="button"
          class="icon btn-flat"
          title={{this.title}}
          {{on "click" this.openInvite}}
        >
          {{icon "fab-discord"}}
        </button>
      {{else}}
        <DMenu
          @identifier="discord-widget"
          @title={{this.title}}
          @icon="fab-discord"
          @triggerClass="icon btn-flat"
          @modalForMobile={{false}}
        >
          <:content>
            <div class="discord-panel">
              {{#if this.warning}}
                <div class="panel-message panel-message-type-warning">
                  {{icon "triangle-exclamation"}}
                  {{this.warning}}
                </div>
              {{else}}
                <iframe
                  src={{this.src}}
                  sandbox="allow-popups allow-popups-to-escape-sandbox allow-same-origin allow-scripts"
                  width="350"
                  height="500"
                  allowtransparency="true"
                  frameborder="0"
                  id="chatwidget"
                  name="chatwidget"
                ></iframe>
              {{/if}}
            </div>
          </:content>
        </DMenu>
      {{/if}}
    </li>
  </template>
}
