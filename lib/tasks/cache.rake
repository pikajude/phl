desc "Benchmark arbitrary stuff"
task benchmark: :environment do
  t = Team.first
  Benchmark.bm do |x|
    1.upto(6) do |i|
      x.report("dark_#{i}") do
        meth = "dark_#{i}".to_sym
        100000.times do
          t.send(meth)
        end
      end
    end
  end
end
