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
        # REMEMBER PUNDIT
        begin
          recipe = Recipe.find(params[:id])

          raise 'Recipe not found' unless recipe # SHOULD THIS BE AN ACTUAL ERROR?

          render json: {
            recipe: RecipeRepresenter.new(recipe).as_json
          }, status: :ok
        rescue => e
          render json: {
            error_message: e.message
          }, status: :not_found
        end
      end

      # POST /api/v1/recipes
      def create
        # COMPLETE THIS
      end
    end
  end
end
