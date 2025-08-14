import Component from "@ember/component";
import { hash } from "@ember/helper";
import { action, computed } from "@ember/object";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";
import ListSetting from "select-kit/components/list-setting";

export default class ExtraGroupClassesGroupEdit extends Component {
  @service dialog;

  tokenSeparator = "|";

  @computed("group.extra_classes")
  get extraClasses() {
    if (this.group.extra_classes) {
      return this.group.extra_classes
        .split(this.tokenSeparator)
        .filter(Boolean);
    }
    return null;
  }

  @action
  extraGroupClassesChanged(value) {
    let newValue = value.join(this.tokenSeparator);
    let group = this.group;
    let oldValue = this.group.extra_classes;

    group.set("extra_classes", newValue);

    return ajax(`/admin/groups/${group.id}/extra_classes`, {
      type: "PUT",
      data: group.getProperties("extra_classes"),
    }).catch(() => {
      group.set("extra_classes", oldValue);
      this.dialog.alert(
        i18n("generic_error_with_reason", {
          error: i18n("extra_group_classes.save_error"),
        })
      );
    });
  }

  <template>
    {{! Only show these fields when editing an existing group }}
    {{#if this.group.id}}

      <div class="control-group">
        <label class="control-label">{{i18n
            "extra_group_classes.title"
          }}</label>

        <label for="extra_classes">
          {{i18n "extra_group_classes.description"}}
        </label>
        <ListSetting
          @name="extra_classes"
          @class="extra-classes"
          @value={{this.extraClasses}}
          @choices={{this.extraClasses}}
          @settingName="name"
          @nameProperty={{null}}
          @valueProperty={{null}}
          @onChange={{this.extraGroupClassesChanged}}
          @options={{hash allowAny=true}}
        />
      </div>
    {{/if}}
  </template>
}
