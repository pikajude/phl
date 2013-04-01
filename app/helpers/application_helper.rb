module ApplicationHelper
  def title c
    content_for(:title) { c }
  end
end
