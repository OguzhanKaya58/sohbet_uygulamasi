import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class SocialLogInButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double buttonHeight;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const SocialLogInButton(
      {Key key,
      @required this.buttonText,
      this.buttonColor,
      this.textColor: Colors.white,
      this.radius: 16,
      this.buttonHeight: 40,
      this.buttonIcon,
      @required this.onPressed})
      : assert(buttonText != null, onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: buttonHeight,
        child: RaisedButton(
          onPressed: onPressed,
          color: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Spreads Collection-if, Collection-For
              // Spreads Yöntemi
              if (buttonIcon != null) ...[
                buttonIcon,
                Text(
                  buttonText,
                  style: TextStyle(color: textColor, fontSize: 18),
                ),
                Opacity(
                  child: buttonIcon,
                  opacity: 0,
                )
              ],
              if (buttonIcon == null) ...[
                Container(),
                Text(
                  buttonText,
                  style: TextStyle(color: textColor, fontSize: 18),
                ),
                Container(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/* Eski Yöntem
 buttonIcon != null ? buttonIcon : Container(),
              Text(
                buttonText,
                style: TextStyle(color: textColor, fontSize: 18),
              ),
              buttonIcon != null
                  ? Opacity(
                      child: buttonIcon,
                      opacity: 0,
                    )
                  : Container(),
 */

/* Collection if Yöntemi
if(buttonIcon != null)
                buttonIcon,
              Text(
                buttonText,
                style: TextStyle(color: textColor, fontSize: 18),
              ),
              if(buttonIcon != null)
                Opacity(
                  child: buttonIcon,
                  opacity: 0,
                ),
 */
