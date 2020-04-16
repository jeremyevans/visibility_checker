module VisibilityChecker
  # Structure holding data on method visibility changes
  VisibilityChange = Struct.new(:method, :defined_in, :original_visibility, :overridden_by, :new_visibility)

  # Return an array of VisibilityChanges for any changes in method visibility in any
  # of the the ancestors of +klass+ before +stop_at+, unless the owner of the method is
  # in +skip_owners+.  This will be an empty array if there are no visibility changes.
  def self.visibility_changes(klass, stop_at: Object, skip_owners: [Kernel])
    meths = {}
    changes = []

    klass.ancestors.each do |mod|
      break if mod == stop_at

      [:public, :private, :protected].each do |vis_type|
        mod.send("#{vis_type}_instance_methods").each do |meth|
          prev_vis_type, prev_mod = meths[meth]
          unless prev_vis_type.nil? || prev_vis_type == vis_type
            owner = mod.instance_method(meth).owner
            unless skip_owners.include?(owner)
              changes << VisibilityChange.new(meth, mod.instance_method(meth).owner, vis_type, prev_mod, prev_vis_type)
            end
          end
          meths[meth] = [vis_type, mod]
        end
      end
    end

    changes
  end

  # Detect visibility changes in the receiver's ancestors.  This should only
  # be used if you are extending a class or module with VisibilityChecker or
  # including it in Class or Module.
  def visibility_changes
    VisibilityChecker.visibility_changes(self)
  end
end
