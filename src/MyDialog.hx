package ;

import flash.geom.Matrix;
import flash.display.GradientType;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.events.MouseEvent;
import flash.display.Shape;
import flash.Lib;
import flash.display.Sprite;
import flash.display.SimpleButton;
import flash.text.TextField;

class MyDialog extends Sprite{

	private var textContainer:Sprite;
	private var textField: TextField;
	private var nextButton: SimpleButton;
	private var choiceButton1: SimpleButton;
	private var choiceButton2: SimpleButton;
	private var textIndex: Int = 0;
	private var currentPattern: Pattern;
	private var patterns: Map<String, Pattern>;

	/**
	* Méthode d'entrée du programme
	**/
	public static function main():Void
	{
		// Construction de notre dialogue
		new MyDialog();
	}

	public function new():Void
	{
		// Appel du constructeur de Sprite
		super();
		patterns = new Map<String, Pattern>();

		// Création des patterns
		var fin: Pattern = {name: "Fin", texts: ["GAME OVER"]};
		var pattern1: Pattern = {name: "Pattern1", texts: ["Bien", "et toi ?"], next: fin};
		var pattern0: Pattern = {name: "Pattern0", texts: ["Salut", "tu", "vas", "bien ?"]};
		var pattern2: Pattern = {name: "Pattern2", texts: ["Bof, pas trop", "je suis bloqué sur un bug"], next: fin};
		// Remplissage de la map
		patterns.set(pattern0.name, pattern0);
		patterns.set(pattern1.name, pattern1);
		patterns.set(pattern2.name, pattern2);

		currentPattern = pattern0;

		textContainer = new Sprite();
		textContainer.x = 100;
		textContainer.y = 50;
		// Gradient pour la frime
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox(400, 200, Math.PI/2, 0, 0);
		textContainer.graphics.beginGradientFill(GradientType.LINEAR,[0xDDDDDD, 0x333333],[0.9,0.5],[0x00, 0xFF], matrix);
		textContainer.graphics.drawRoundRect(0, 0, 400, 200, 10, 10);
		textContainer.graphics.endFill();

		textField = new TextField();
		textField.x = 20;
		textField.y = 20;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textContainer.addChild(textField);

		//Dessine le bouton
		var buttonContent = new Sprite();
		var shape = new Shape();
		shape.graphics.beginFill(0x0000FF);
		shape.graphics.drawRoundRect(0, 0, 100, 20, 20, 20);
		shape.graphics.endFill();
		var buttonText = new TextField();
		buttonText.autoSize = TextFieldAutoSize.CENTER;
		buttonText.defaultTextFormat = new TextFormat("_sans", 10, 0xFFFFFF);
		buttonText.text = "Suivant";
		buttonContent.addChild(shape);
		buttonContent.addChild(buttonText);
		// Centre le texte
		buttonText.x = shape.width / 2 - buttonText.width / 2;
		buttonText.y = shape.height /2 - buttonText.height / 2;
		// 3 états du bouton + zone de clic
		nextButton = new SimpleButton(buttonContent, buttonContent, buttonContent, buttonContent);
		nextButton.useHandCursor = true;
		nextButton.x = 500;
		nextButton.y = 350;
		nextButton.addEventListener(MouseEvent.CLICK, onButtonClick);

		//Dessine les boutons de choix
		var buttonContent = new Sprite();
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRoundRect(0, 0, 100, 20, 20, 20);
		shape.graphics.endFill();
		var buttonText = new TextField();
		buttonText.autoSize = TextFieldAutoSize.CENTER;
		buttonText.defaultTextFormat = new TextFormat("_sans", 10, 0xFFFFFF);
		buttonText.text = "Non";
		buttonContent.addChild(shape);
		buttonContent.addChild(buttonText);
		// Centre le texte
		buttonText.x = shape.width / 2 - buttonText.width / 2;
		buttonText.y = shape.height /2 - buttonText.height / 2;
		// 3 états du bouton + zone de clic
		choiceButton1 = new SimpleButton(buttonContent, buttonContent, buttonContent, buttonContent);
		choiceButton1.name = "non";
		choiceButton1.y = 350;
		choiceButton1.addEventListener(MouseEvent.CLICK, onButtonClick);

		var buttonContent = new Sprite();
		var shape = new Shape();
		shape.graphics.beginFill(0x00FF00);
		shape.graphics.drawRoundRect(0, 0, 100, 20, 20, 20);
		shape.graphics.endFill();
		var buttonText = new TextField();
		buttonText.autoSize = TextFieldAutoSize.CENTER;
		buttonText.defaultTextFormat = new TextFormat("_sans", 10, 0xFFFFFF);
		buttonText.text = "Oui";
		buttonContent.addChild(shape);
		buttonContent.addChild(buttonText);
		// Centre le texte
		buttonText.x = shape.width / 2 - buttonText.width / 2;
		buttonText.y = shape.height /2 - buttonText.height / 2;
		// 3 états du bouton + zone de clic
		choiceButton2 = new SimpleButton(buttonContent, buttonContent, buttonContent, buttonContent);
		choiceButton2.name = "oui";
		choiceButton2.x = 500;
		choiceButton2.y = 350;
		choiceButton2.addEventListener(MouseEvent.CLICK, onButtonClick);

		display();
	}

	private function display():Void
	{
		addChild(textContainer);
		addChild(nextButton);

		Lib.current.addChild(this);
	}

	private function onButtonClick(e: MouseEvent):Void
	{
		var name: String = null;
		if(Std.is(e.currentTarget, SimpleButton))
			name = cast(e.currentTarget, SimpleButton).name;
		displayNextText(name);
	}

	private function displayNextText(?choice: String):Void
	{
		// On pourrait aussi désactiver le bouton quand currentPattern est null
		// nextButton.enabled = false;
		// ou carrément lui supprimer son listener
		// nextButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
		if(currentPattern != null){
			// Vérifier l'indice pour ne pas sortir du tableau
			if(textIndex < currentPattern.texts.length){
				setText(currentPattern.texts[textIndex]);
				textIndex++;
				// En une ligne
				// setText(texts[textIndex++]);

				// Détection de fin de pattern
				if(textIndex == currentPattern.texts.length && currentPattern.next == null && currentPattern.name != "Fin"){
					// Ajout du bouton alternatif
					addChild(choiceButton1);
					addChild(choiceButton2);
					removeChild(nextButton);
				}
			}
			else if(currentPattern.next != null){
				currentPattern = currentPattern.next;
				if(currentPattern.name == "Fin")
					removeChild(nextButton);
				textIndex = 0;
				displayNextText();
			}
			else if(choice != null){
				currentPattern = switch(choice){
					case "oui" : patterns.get("Pattern1"); // ou patterns["Pattern1"]
					case "non" : patterns.get("Pattern2");
					default : throw "Je ne connais pas ce choix";
				}
				textIndex = 0;
				removeChild(choiceButton1);
				removeChild(choiceButton2);
				addChild(nextButton);
				displayNextText();
			}
		}
	}

	// inline : optimisation à la compilation
	private inline function setText(text:String):Void
	{
		textField.text = text;
	}
}

typedef Pattern = {
	var name: String;
	var texts: Array<String>;
	@:optional var next: Pattern;
}