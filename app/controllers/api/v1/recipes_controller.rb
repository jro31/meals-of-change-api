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

        # Don't return recipes that don't have at least one ingredient, and one step
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
        # Throw error if tries to add more than 15 tags

        @recipe = Recipe.new(recipe_params)
        authorize @recipe

        @recipe.user = current_user
        find_or_create_tags

        # binding.irb

        # puts @recipe.ingredients.inspect
        # puts @recipe.ingredients.first.recipe.inspect
        # puts @recipe.steps.inspect
        # puts @recipe.steps.first.recipe.inspect
        # puts @recipe.save!

        if @recipe.save
          puts '🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈'
        else
          puts '🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉🙉'
        end
      end

      private

      def recipe_params
        params.require(:recipe).permit(:name, :time_minutes, :preface, ingredients_attributes: [
          :amount, :food, :preparation, :optional
        ], steps_attributes: [
          :position, :instructions
        ])
      end

      def find_or_create_tags
        return unless params[:recipe][:tags].reject(&:blank?).any?

        @recipe.tags << params[:recipe][:tags].map{ |tag_name| Tag.find_or_initialize_by(name: tag_name.downcase) }
      end
    end
  end
end
