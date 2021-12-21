module Api
  module V1
    class TagsController < Api::V1::BaseController
      # GET /api/v1/tags
      # GEt /api/v1/tags?limit=10
      def index
        begin
          @tags = policy_scope(Tag).joins(:recipe_tags)
                                   .group('tags.id')
                                   .order('count(tags.id) DESC')
                                   .limit(params[:limit])
          render json: { tags: @tags.pluck(:name).map(&:capitalize) }, status: :ok
        rescue => e
          @skip_after_action = true
          render json: {
            error_message: e.message
          }, status: :not_found
        end
      end
    end
  end
end
