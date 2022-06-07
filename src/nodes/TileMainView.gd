extends VBoxContainer

class_name TileMainView


signal ruleset_view_called()
signal template_view_called()

onready var input_texture := $InputTextureView
onready var ruleset_option := $RulesetContainer/RulesetOptionButton
onready var ruleset_texture := $RulesetContainer/ScrollContainer/TextureRect
onready var template_option := $TemplateContainer/TemplateOptionButton
onready var template_texture := $TemplateContainer/TextureRect


func load_data(tile: TileInTree):
	if tile.texture_path != "":
		input_texture.load_data(tile)
	if tile.loaded_ruleset.is_loaded:
		ruleset_option.text = tile.loaded_ruleset.get_name()
		ruleset_texture.texture = tile.loaded_ruleset.preview_texture
		add_ruleset_highlights(tile.loaded_ruleset)
		Helpers.populate_project_file_option(ruleset_option, 
			State.current_dir + "/" + Const.RULESET_DIR, 
			funcref(Helpers, "scan_for_rulesets_in_dir"),
			tile.ruleset_path)
	if tile.template_path != "":
		template_option.text = tile.template_path.get_file()
		template_texture.texture = tile.loaded_template
		Helpers.populate_project_file_option(template_option, 
			State.current_dir + "/" + Const.TEMPLATE_DIR, 
			 funcref(Helpers, "scan_for_templates_in_dir"),
			 tile.template_path)


func add_ruleset_highlights(ruleset: Ruleset):
	for old_highlight in ruleset_texture.get_children():
		old_highlight.queue_free()
	for i in ruleset.get_parts().size():
		var highlight := preload("res://src/nodes/PartHighlight.tscn").instance()
		ruleset_texture.add_child(highlight)
		highlight.rect_position.x = i * (ruleset.PREVIEW_SIZE_PX + ruleset.PREVIEW_SPACE_PX)
		highlight.set_id(i + 1)
		highlight.connect("focused", self, "on_part_highlight_focused")
		highlight.connect("unfocused", self, "on_part_highlight_unfocused")


func on_part_highlight_focused(part: PartHighlight):
	input_texture.change_part_highlight(part.id, true)


func on_part_highlight_unfocused(part: PartHighlight):
	input_texture.change_part_highlight(part.id, false)


func _on_RulesetButton_pressed():
	emit_signal("ruleset_view_called")


func _on_TemplateButton_pressed():
	emit_signal("template_view_called")


func _on_RulesetOptionButton_item_selected(index):
	State.update_tile_ruleset(ruleset_option.get_item_metadata(index))


func _on_TemplateOptionButton_item_selected(index):
	State.update_tile_template(template_option.get_item_metadata(index))


