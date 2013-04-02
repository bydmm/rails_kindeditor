module RailsKindeditor
  module Helper
    def kindeditor_tag(name, content = nil, options = {})
      id = sanitize_to_id(name)
      input_html = { :id => id }.merge(options.delete(:input_html) || {})
      output = ActiveSupport::SafeBuffer.new
      output << text_area_tag(name, content, input_html)
      output << javascript_tag(js_replace(id, options))
    end
    
    def kindeditor(name, method, options = {})
      input_html = (options.delete(:input_html) || {})
      hash = input_html.stringify_keys
      instance_tag = ActionView::Base::InstanceTag.new(name, method, self, options.delete(:object))
      instance_tag.send(:add_default_name_and_id, hash)      
      output_buffer = ActiveSupport::SafeBuffer.new
      output_buffer << instance_tag.to_text_area_tag(input_html)
      output_buffer << javascript_tag(js_replace(hash['id'], options))
    end
    
    private
    def js_replace(dom_id, options = {})
      editor_id = options[:editor_id].nil? ? '' : "#{options[:editor_id].to_s.downcase} = "
      if options[:window_onload]
        "window.onload = function() {
          #{editor_id}KindEditor.create('##{dom_id}', #{get_options(options).to_json});
        }"
      else
        "KindEditor.ready(function(K){
        	#{editor_id}K.create('##{dom_id}', #{get_options(options).to_json});
        });"
      end
    end

    def get_options(options)
      options.reverse_merge!(:items => RailsKindeditor.items)
      options.delete(:editor_id)
      options.delete(:window_onload)
      options.reverse_merge!(:width => '100%')
      options.reverse_merge!(:height => 300)
      options.reverse_merge!(:allowFileManager => true)
      options.merge!(:uploadJson => '/kindeditor/upload')
      options.merge!(:fileManagerJson => '/kindeditor/filemanager')
      if options[:simple_mode] == true
        options.delete(:simple_mode)
        options.merge!(:items => %w{fontname fontsize | forecolor hilitecolor bold italic underline removeformat | justifyleft justifycenter justifyright insertorderedlist insertunorderedlist | emoticons image link})
      end
      options
    end    
  end
  
  module Builder
    def kindeditor(method, options = {})
      @template.send("kindeditor", @object_name, method, objectify_options(options))
    end
  end
end