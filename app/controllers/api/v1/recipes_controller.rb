module Api
  module V1
    class RecipesController < Api::V1::BaseController
      # GET /api/v1/recipes
      # GET /api/v1/recipes?limit=10
      # GET /api/v1/recipes?offset=5
      # GET /api/v1/recipes?limit=10&offset=5
      # GET /api/v1/recipes?ids_array=true
      # GET /api/v1/recipes?user_id=1
      # GET /api/v1/recipes?tag_name=thai+food
      # GET /api/v1/recipes?query=garlic+bread
      def index
        begin
          filter_recipes
          render json: recipes_return, status: :ok
        rescue => e
          @skip_after_action = true
          render json: {
            error_message: e.message
          }, status: :not_found
        end

        # TODO - Don't return recipes that don't have at least one ingredient, and one step?
        # TODO - Prioritise recipes with photos?
      end

      # GET /api/v1/recipes/:id
      def show
        begin
          recipe = Recipe.find(params[:id])
          authorize recipe

          render json: {
            recipe: RecipeRepresenter.new(recipe, current_user).as_json
          }, status: :ok
        rescue => e
          @skip_after_action = true
          render json: {
            error_message: e.message
          }, status: :not_found
        end
      end

      # POST /api/v1/recipes
      def create
        begin
          @recipe = Recipe.new(recipe_params)
          authorize @recipe

          attach_photo
          set_user
          find_or_create_tags

          @recipe.save!

          render json: {
            recipe: RecipeRepresenter.new(@recipe).as_json
          }, status: :created
        rescue Pundit::NotAuthorizedError
          render json: {
            error_message: 'User must be signed-in to create a recipe'
          }, status: :unauthorized
        rescue => e
          render json: {
            error_message: e.message
          }, status: :unprocessable_entity
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

      def filter_recipes
        if params[:user_id]
          user = User.find(params[:user_id])
          @recipes = policy_scope(Recipe).where(user: user)
                                         .order(created_at: :desc)
                                         .limit(params[:limit])
                                         .offset(params[:offset])
          @filter_title = "#{user.display_name}'s recipes"
        elsif params[:tag_name]
          raise 'tag not found' unless tag = Tag.find_by(name: params[:tag_name].downcase)

          @recipes = policy_scope(Recipe).joins(:tags)
                                         .where(tags: { id: tag.id })
                                         .order(created_at: :desc)
                                         .limit(params[:limit])
                                         .offset(params[:offset])
          @filter_title = "#{tag.name.split.map(&:capitalize).join(' ')} recipes"
        elsif params[:query]
          @recipes = policy_scope(Recipe).search_by_recipe_name_ingredient_food_and_tag_name(params[:query])
                                         .limit(params[:limit])
                                         .offset(params[:offset])
          @filter_title = "\"#{params[:query]}\" recipes"
        else
          @recipes = policy_scope(Recipe).order(created_at: :desc)
                                         .limit(params[:limit])
                                         .offset(params[:offset])
        end
      end

      def recipes_return
        if ActiveModel::Type::Boolean.new.cast(params[:ids_array])
          { recipe_ids: @recipes.unscoped.pluck(:id) }
        else
          { recipes: RecipesRepresenter.new(@recipes).as_json, filter_title: @filter_title || '' }
        end
      end

      def attach_photo
        @recipe.small_photo.attach(params[:recipe][:small_photo_blob_signed_id]) if params[:recipe][:small_photo_blob_signed_id].present?
        @recipe.large_photo.attach(params[:recipe][:large_photo_blob_signed_id]) if params[:recipe][:large_photo_blob_signed_id].present?
      end

      def set_user
        @recipe.user = current_user
      end

      def find_or_create_tags
        return unless params[:recipe][:tags].reject(&:blank?).any?

        @recipe.tags << params[:recipe][:tags].reject(&:blank?).map{ |tag_name| Tag.find_or_initialize_by(name: tag_name.downcase) }
      end
    end
  end
end
