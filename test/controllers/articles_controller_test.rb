require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  setup do
    @article = articles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should show article" do
    get :show, id: @article
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @article
    assert_response :success
  end

  test "should update article" do
    patch :update, id: @article, article: { body: @article.body, title: @article.title }
    assert_redirected_to article_path(assigns(:article))
  end

  test "should destroy article" do
    assert_difference('Article.count', -1) do
      delete :destroy, id: @article
    end

    assert_redirected_to articles_path
  end
end

class ArticleNewControllerTest < ActionController::TestCase
  setup do
    @controller = ArticlesController.new
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should have form elements" do
    get :new

    assert_select "form[action='/articles'][method='post']" do
      assert_select "input[type='text'][name='article[title]']"
      assert_select "textarea[name='article[body]']"
      assert_select "button[type='submit']", 'Save'
    end
  end
end

class ArticleCreateControllerTest < ActionController::TestCase
  setup do
    @controller = ArticlesController.new
  end

  test "should create article" do
    assert_difference('Article.count') do
      post :create, article: { body: 'Hi', title:'1st post' }
    end

    assert_redirected_to article_path(assigns(:article))
  end

  test "should not create without title" do
    post :create, article: { body:'hello', title:'' }
    article = assigns(:article)

    assert_response :success
    assert_template :new
    assert_not article.persisted?
  end

  test "should display title errors" do
    post :create, article: { body:'hello', title:'' }
    article = assigns(:article)

    assert_select "form[action='/articles'][method='post']" do
      assert_select "div.form-group.has-error" do

        css_select("label.control-label[for='title']").each do |label|
          article.errors.full_messages.each do |error|
            assert_match /#{error}/m, label.text.squish
          end
        end
      end
    end
  end

  test "should not create without body" do
    post :create, article: { title:'hello', body:'' }
    article = assigns(:article)

    assert_response :success
    assert_template :new
    assert_not article.persisted?
  end

  test "should display body errors" do
    post :create, article: { title:'hello', body:'' }
    article = assigns(:article)

    assert_select "form[action='/articles'][method='post']" do
      assert_select "div.form-group.has-error" do

        css_select("label.control-label[for='body']").each do |label|
          article.errors.full_messages.each do |error|
            assert_match /#{error}/m, label.text.squish
          end
        end
      end
    end
  end
end
