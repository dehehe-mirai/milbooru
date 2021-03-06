require 'test_helper'

class FavoriteGroupsControllerTest < ActionDispatch::IntegrationTest
  context "The favorite groups controller" do
    setup do
      @user = create(:user)
      @favgroup = create(:favorite_group, creator: @user)
    end

    context "index action" do
      should "render" do
        get favorite_groups_path
        assert_response :success
      end
    end

    context "show action" do
      should "render" do
        get favorite_group_path(@favgroup)
        assert_response :success
      end
    end

    context "new action" do
      should "render" do
        get_auth new_favorite_group_path, @user
        assert_response :success
      end
    end

    context "create action" do
      should "render" do
        post_auth favorite_groups_path, @user, params: { favorite_group: FactoryBot.attributes_for(:favorite_group) }
        assert_redirected_to favorite_group_path(FavoriteGroup.last)
      end
    end

    context "edit action" do
      should "render" do
        get_auth edit_favorite_group_path(@favgroup), @user
        assert_response :success
      end
    end

    context "update action" do
      should "update posts" do
        @posts = create_list(:post, 2)
        put_auth favorite_group_path(@favgroup), @user, params: { favorite_group: { name: "foo", post_ids: @posts.map(&:id).join(" ") } }

        assert_redirected_to @favgroup
        assert_equal("foo", @favgroup.reload.name)
        assert_equal(@posts.map(&:id), @favgroup.post_ids)
      end
    end

    context "destroy action" do
      should "render" do
        delete_auth favorite_group_path(@favgroup), @user
        assert_redirected_to favorite_groups_path
      end
    end

    context "add_post action" do
      should "render" do
        as_user do
          @post = FactoryBot.create(:post)
        end

        put_auth add_post_favorite_group_path(@favgroup), @user, params: {post_id: @post.id, format: "js"}
        assert_response :success
        @favgroup.reload
        assert_equal([@post.id], @favgroup.post_ids)
      end
    end
  end
end
