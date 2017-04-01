module Hobbit
  module Helpers
    module View

      def active_class(path)
        request.path_info == path ? 'active' : nil
      end

    end
  end
end