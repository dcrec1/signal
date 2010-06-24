shared_examples_for 'statusable' do
  context "responding to status" do
    it "should return #{Status::SUCCESS} on success" do
      subject.success = true
      subject.status.should eql(Status::SUCCESS)
    end

    it "should return #{Status::FAIL} on failure" do
      subject.success = false
      subject.status.should eql(Status::FAIL)
    end
  end
end
