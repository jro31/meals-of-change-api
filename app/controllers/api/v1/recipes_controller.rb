module Api
  module V1
    class RecipesController < Api::V1::BaseController

      # GET /api/v1/recipes
      def index
        # COMPLETE THIS

        # Include pagination (see rails-nile)
        # Must be filterable by tag,
        # search query (searching recipe name, ingredient food and tag name)
        # and user
      end

      # GET /api/v1/recipes/:id
      def show
        begin
          recipe = Recipe.find(params[:id])
          authorize recipe

          render json: {
            recipe: RecipeRepresenter.new(recipe).as_json
          }, status: :ok
        rescue => e
          skip_after_action :verify_authorized
          render json: {
            error_message: e.message
          }, status: :not_found
        end
      end

      # POST /api/v1/recipes
      def create
        # COMPLETE THIS

        # Find or create tags - save as lower case
        # Throw error if tries to add more than 15 tags
      end
    end
  end
end
