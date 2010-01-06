require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Diffaroo::DeleteDelta do
  describe ".new" do
    it "takes one argument" do
      proc { Diffaroo::DeleteDelta.new(:foo)      }.should_not raise_error(ArgumentError)
      proc { Diffaroo::DeleteDelta.new(:foo, :bar)}.should     raise_error(ArgumentError)
    end
  end

  describe "#node" do
    it "returns the initalizer argument" do
      Diffaroo::DeleteDelta.new(:foo).node.should == :foo
    end
  end

  describe "#apply!" do
    context "for an atomic node delta" do
      it "should delete the node" do
        doc1 = xml { root { a1 } }
        doc2 = xml { root }
        node = doc1.at_css("a1")
        delta = Diffaroo::DeleteDelta.new node

        delta.apply!(doc1)

        doc1.at_css("a1").should be_nil
        node.parent.should == nil
      end
    end

    context "for a subtree delta" do
      it "should delete the subtree" do
        doc1 = xml { root { a1 { b1 ; b2 "hello" } } }
        doc2 = xml { root }
        node = doc1.at_css("a1")
        delta = Diffaroo::DeleteDelta.new node

        delta.apply!(doc1)

        doc1.at_css("a1,b1,b2").should be_nil
        node.parent.should == nil
      end
    end
  end
end
