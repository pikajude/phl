module ReportsHelper
  def time_spans
    content_tag :li, class: "time" do
      content_tag :table do
        content_tag :tr do
          content_tag(:td, "0:00") +
          1.upto(5).map do |i|
            content_tag(:td, "#{i-1}:30") +
            content_tag(:td, "#{i}:00")
          end.inject(:+)
        end
      end
    end
  end
end
