# encoding: utf-8
require_relative "test_helper"

class HelloControllerTest < ActionController::TestCase
  def body
    response.body.chomp
  end

  def test_translate
    get :translate
    assert_equal "Hi!", body
  end

  def test_locale_option
    get :locale_option
    assert_equal "Привіт", body
  end

  def test_missing_translation
    get :missing_translation
    assert_equal '<span class="translation_missing" title="translation missing: en.missing">Missing</span>', body
  end

  def test_partial_scope
    get :partial_scope
    assert_equal "Hello, Rails!", body
  end

  def test_html_safe_underscored
    get :html_safe_underscored
    assert_equal "<span>No escaping</span>", body
  end

  def test_html_safe_key
    get :html_safe_key
    assert_equal "<span>No escaping</span>", body
  end

  def test_html_unsafe
    get :html_unsafe
    assert_equal "&lt;span&gt;No escaping?&lt;/span&gt;", body
  end

  def test_raise_error
    assert_raises(ActionView::Template::Error) { get :raise_error }
  end

  this = self
  Dummy::Application.routes.draw do
    this.instance_methods(false).grep(/^test_/).each do |method|
      route = method[/^test_(.+)$/, 1]
      get route => "hello##{route}"
    end
  end
end

