import { computed } from "@ember/object";
import discourseComputed from "discourse-common/utils/decorators";
import { withPluginApi } from "discourse/lib/plugin-api";

// Takes a list of classes like my-class1|my-class2
// and returns an array of the form ["g-my-class1", "g-my-class2"]
function parseClasses(classList, prefix = "g-") {
  let separator = "|";
  return classList.split(separator).map((c) => prefix + c);
}

export default {
  name: "extra-group-classes",
  initialize() {
    // decorate posts within topics
    withPluginApi("0.11.4", (api) => {
      api.includePostAttributes("extra_classes");
      api.addPostClassesCallback((attrs) => {
        if (attrs.extra_classes) {
          return parseClasses(attrs.extra_classes);
        }
      });

      api.modifyClass("component:user-card-contents", {
        @discourseComputed("user")
        extraClasses(user) {
          if (user && user.primary_group_extra_classes) {
            let classes = user.primary_group_extra_classes;
            classes = parseClasses(classes).join(" ");
            return classes;
          }
        },
        classNameBindings: ["extraClasses"],
      });

      api.modifyClass("controller:user", {
        @discourseComputed("model.primary_group_name")
        primaryGroup(group) {
          let groupClasses = this._super(...arguments);
          if (this.model && this.model.primary_group_extra_classes) {
            let classes = this.model.primary_group_extra_classes;
            classes = parseClasses(classes).join(" ");
            groupClasses = `${groupClasses} ${classes}`;
          }
          return groupClasses;
        },
      });

      // decorate group posts
      api.modifyClass("component:group-post", {
        extraClasses: computed(function () {
          if (this.post && this.post.extra_classes) {
            let classes = this.post.extra_classes;
            classes = parseClasses(classes).join(" ");
            return classes;
          }
        }),
        classNameBindings: ["extraClasses"],
      });

      // decorate extra classes on body of current user
      if (api.getCurrentUser()) {
        let user = api.getCurrentUser();
        if (user.primary_group_extra_classes) {
          let classes = parseClasses(
            user.primary_group_extra_classes,
            "primary-group-extra-"
          );
          document.querySelector("body").classList.add(...classes);
        }
      }

      // decorate participant lists
      api.addTopicParticipantClassesCallback((attrs) => {
        if (attrs.primary_group_extra_classes) {
          return parseClasses(attrs.primary_group_extra_classes);
        }
      });
    });
  },
};
