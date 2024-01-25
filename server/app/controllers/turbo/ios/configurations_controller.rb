module Turbo
  module Ios
    class ConfigurationsController < ApplicationController
      def ios_v1
        render json: {
          settings: {},
          rules: [
            {
              patterns: [
                "/new$",
                "/edit$"
              ],
              properties: {
                context: "modal"
              }
            },
            {
              patterns: [
                "/native_todos$"
              ],
              properties: {
                "view-controller": "todos"
              }
            }
          ]
        }
      end
    end
  end
end
