require './lib/coco'
COVERAGE_1 = {'the/filename' => [nil, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]}

describe Coco::ConsoleFormatter do
  
  it "must return percents and filename" do
    result = Coco::ConsoleFormatter.format COVERAGE_1
    result.should == "90% the/filename\n"
  end
  
end
