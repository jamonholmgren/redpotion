class StyleSheetForUIImageViewStylerTests < RubyMotionQuery::Stylesheet
  def ui_image_view_placeholder(st)
    st.placeholder_image = UIImage.imageNamed('grumpy_cat')
  end

  def ui_image_view_remote(st)
    ui_image_view_placeholder(st)
    st.remote_image = 'http://somehost/image'
  end

  def ui_image_view_remote_nsurl(st)
    ui_image_view_placeholder(st)
    st.remote_image = NSURL.URLWithString('http://somehost/image')
  end

  def ui_image_view_remote_no_placeholder(st)
    st.remote_image = 'http://somehost/image'
  end

  def ui_image_view_remote_fail(st)
    ui_image_view_placeholder(st)
    st.remote_image = 'http://somehost/image_fail'
  end

end

describe 'RubyMotionQuery styler: UIImageView' do
  extend WebStub::SpecHelpers

  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = StyleSheetForUIImageViewStylerTests
    @view_klass = UIImageView

    @image = load_image('homer')
    @grumpy_cat = UIImage.imageNamed('grumpy_cat')
    @url = 'http://somehost/image'
    WebStub::API.stub_request(:get, @url).to_return(body: load_image('homer'), content_type: "image/jpeg")
  end

  it "should set a placeholder image" do
    view = @vc.rmq.append!(@view_klass, :ui_image_view_placeholder)
    view.image.should == @grumpy_cat
  end

  it "should set a remote image URL string" do
    view = @vc.rmq.append!(@view_klass, :ui_image_view_remote)
    view.image.should == @grumpy_cat

    wait 0.1 do
      view.image.should.not == @grumpy_cat
    end
  end

  it "should set a remote image with a NSURL instance" do
    view = @vc.rmq.append!(@view_klass, :ui_image_view_remote_nsurl)
    view.image.should == @grumpy_cat

    wait 0.1 do
      view.image.should.not == @grumpy_cat
    end
  end

  it "should keep the placeholder image when the remote image fails" do
    view = @vc.rmq.append!(@view_klass, :ui_image_view_remote_fail)
    view.image.should == @grumpy_cat

    wait 0.1 do
      view.image.should == @grumpy_cat
    end
  end

  it "should set a remote image and no placeholder" do
    view = @vc.rmq.append!(@view_klass, :ui_image_view_remote_no_placeholder)
    view.image.should == nil

    wait 0.1 do
      view.image.should.not == nil
    end
  end
end
