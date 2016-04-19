require 'test_helper'

class CommentsCreateControllerTest < ActionController::TestCase
  setup do
    @controller = CommentsController.new
    @comment = comments(:one)
    @article = articles(:one)
  end

  test "should create comment" do
    assert_difference('@article.comments.count') do
      post :create,
        comment: {
          body: @comment.body,
          email: @comment.email,
          name: @comment.name,
          website: @comment.website },
        article_id:@article.to_param,
        format: :js
    end

    assert :success
    assert_template :create
  end

  test "should not create without email" do
    [ '', 'asdfadf', 'adfad@adsf' ].each do |invalid_email|
      assert_no_difference('@article.comments.count') do
        post :create,
          comment: {
            body: @comment.email,
            email: invalid_email,
            name: @comment.name },
          article_id:@article.to_param,
          format: :js
      end

      assert_template :new
    end
  end

  test "should not create without comment body" do
    assert_no_difference('@article.comments.count') do
      post :create,
        comment: {
          body:'',
          email: @comment.email,
          name: @comment.name },
        article_id:@article.to_param,
        format: :js
    end

    assert_template :new
  end

  test "should not create without name" do
    assert_no_difference('@article.comments.count') do
      post :create,
        comment: {
          body: @comment.body,
          email: @comment.email,
          name: '' },
        article_id:@article.to_param,
        format: :js
    end

    assert_template :new
  end
end
