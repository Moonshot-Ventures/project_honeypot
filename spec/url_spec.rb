require "spec_helper"

describe ProjectHoneypot::Url do
  describe "with honeypot response" do
    let(:url) { ProjectHoneypot::Url.new("127.0.0.1", "127.1.63.3") }

    it "is safe" do
      url.should_not be_safe

      url.safe?(score: 63).should be_false
      url.safe?(score: 64).should be_true

      url.safe?(last_activity: 1).should be_false
      url.safe?(last_activity: 2).should be_true

      url.safe?(last_activity: 2, score: 64).should be_true
      url.safe?(last_activity: 1, score: 64).should be_false
      url.safe?(last_activity: 2, score: 63).should be_false

      url.safe?(offenses: [:comment_spammer]).should be_true
      url.safe?(offenses: [:suspicious, :comment_spammer]).should be_false
    end

    it "has the correct latest activity" do
      url.last_activity.should == 1
    end

    it "has the correct score" do
      url.score.should == 63
    end

    it "has the correct offenses" do
      url.offenses.should include(:suspicious)
      url.offenses.should include(:harvester)
      url.offenses.should_not include(:comment_spammer)
      url.should be_suspicious
      url.should be_harvester
      url.should_not be_comment_spammer
    end
  end

  describe "with search engine honeypot response" do
    subject { ProjectHoneypot::Url.new("127.0.0.1", "127.0.9.0") }
    it { should be_safe }
    it { should be_search_engine }
  end

  describe "with nil honeypot response" do
    subject { ProjectHoneypot::Url.new("127.0.0.1", nil) }
    it { should be_safe }
  end
end
