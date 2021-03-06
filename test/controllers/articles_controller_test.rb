require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  setup do
    @article = articles(:one)
    stub_authentication
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
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

class ArticlesNewControllerTest < ActionController::TestCase
  setup do
    @controller = ArticlesController.new
    stub_authentication
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

class ArticlesCreateControllerTest < ActionController::TestCase
  setup do
    @controller = ArticlesController.new
    stub_authentication
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

class ArticlesShowControllerTest < ActionController::TestCase
  setup do
    @controller = ArticlesController.new
    @article = articles(:one)
  end

  test "should show article" do
    get :show, id: @article
    assert_response :success
    assert_template :show
  end

  test "should have an seo friendly url" do
    assert_routing \
      "/articles/#{@article.id}-#{@article.title.parameterize}", \
      { controller: "articles", action: "show", id: @article.to_param }
  end

  test "should render body as markdown" do
    article_content = Redcarpet::Markdown.
      new(Redcarpet::Render::HTML).
      render @article.body
    get :show, id: @article

    assert_select '.article .content h1', /Heading ONE/m
  end

  test "should display created date" do
    get :show, id: @article

    # local time gem default time
    # https://github.com/basecamp/local_time#time-and-date-helpers
    assert_select '.article .meta', \
      /#{@article.created_at.strftime('%B %e, %Y %l:%M%P')}/m
  end

  test "should display author" do
    get :show, id: @article

    assert_select '.article .meta', /Anonymous/m
  end
end

class ArticlesCommentsControllerTest < ActionController::TestCase
  setup do
    @controller = ArticlesController.new
    @article = articles(:one)
  end

  test "should have new comment form elements" do
    get :show, id: @article

    assert_select "form[action='#{article_comments_path(@article,@comment)}'][method='post']" do
      assert_select "textarea[name='comment[body]']"

      %w[ name website email ].each do |field|
        assert_select "input[type='text'][name='comment[#{field}]']"
      end
    end
  end

  test "should display comments" do
    get :show, id: @article

    @article.comments.each do |comment|
      assert_select ".comments blockquote", /#{comment.body}/m
    end
  end
end

class ArticlesAuthenticationControllerTest < ActionController::TestCase
  setup do
    @article = articles(:one)
    @controller = ArticlesController.new
  end

  test "should authenticate get edit" do
    get :edit, id: @article
    assert_redirected_to new_author_session_url
  end

  test "should authenticate update article" do
    patch :update, id: @article, article: { body: @article.body, title: @article.title }
    assert_redirected_to new_author_session_url
  end

  test "should authenticate destroy article" do
    delete :destroy, id: @article
    assert_redirected_to new_author_session_url
  end

  test "should authenticate get new" do
    get :new
    assert_redirected_to new_author_session_url
  end

  test "should authenticate create article" do
    post :create, article: { body: 'Hi', title:'1st post' }
    assert_redirected_to new_author_session_url
  end
  
  test "should display login link" do
    get :index
    login_path = Regexp.escape new_author_session_path

    assert_match /\<a.*href="#{login_path}.*"\>/im, response.body.squish
  end
  
  test "should display logout link" do
    stub_authentication
    get :index
    logout_path = Regexp.escape destroy_author_session_path

    assert_match /\<a.*href="#{logout_path}".*\>/im, response.body.squish
  end
end
