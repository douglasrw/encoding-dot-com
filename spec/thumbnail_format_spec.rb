require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Encoding.com Thumbnail Format" do

  it "should have an output attribute of 'thumbnail'" do
    EncodingDotCom::ThumbnailFormat.new.output.should == "thumbnail"
  end

  it "should return a ThumbnailFormat if the output is 'thumbnail'" do
    EncodingDotCom::Format.create("output" => "thumbnail").should be_instance_of(EncodingDotCom::ThumbnailFormat)
  end
  
  it "should produce a format node in the xml output" do
    format = EncodingDotCom::ThumbnailFormat.new
    Nokogiri::XML::Builder.new do |b|
      format.build_xml(b)
    end.to_xml.should have_xpath("/format")
  end

  it "should produce an output node in the xml output" do
    format = EncodingDotCom::ThumbnailFormat.new
    Nokogiri::XML::Builder.new do |b|
      format.build_xml(b)
    end.to_xml.should have_xpath("/format/output[text()='thumbnail']")
  end

  describe "valid times" do
    it "can be a number greater than 0.01" do
      lambda { EncodingDotCom::ThumbnailFormat.new("time" => "0") }.should raise_error(EncodingDotCom::IllegalFormatAttribute)
      lambda { EncodingDotCom::ThumbnailFormat.new("time" => "0.5") }.should_not raise_error
    end

    it "can be specified in HH:MM::SS.ms format" do
      lambda { EncodingDotCom::ThumbnailFormat.new("time" => "00:00:01.5") }.should_not raise_error
    end
  end

  describe "valid dimensions" do
    it "should be a positive integer height" do
      lambda { EncodingDotCom::ThumbnailFormat.new("height" => -1) }.should raise_error(EncodingDotCom::IllegalFormatAttribute)
      lambda { EncodingDotCom::ThumbnailFormat.new("height" => 1) }.should_not raise_error      
    end

    it "should be a positive integer width" do
      lambda { EncodingDotCom::ThumbnailFormat.new("width" => -1) }.should raise_error(EncodingDotCom::IllegalFormatAttribute)
      lambda { EncodingDotCom::ThumbnailFormat.new("width" => 1) }.should_not raise_error      
    end
  end
end
