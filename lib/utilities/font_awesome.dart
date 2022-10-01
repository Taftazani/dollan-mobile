import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class FontAwesome {
  IconData getFontAwesome(String fontname){
    switch(fontname){
      case 'pantai':
        return FontAwesomeIcons.digitalOcean;
        break;
      case 'upacara':
        return FontAwesomeIcons.certificate;
        break;
      case 'hiking':
        return FontAwesomeIcons.hiking;
        break;
      case 'pantai':
        return FontAwesomeIcons.borderAll;
        break;
      case 'pantai':
        return FontAwesomeIcons.digitalOcean;
        break;
      case 'pantai':
        return FontAwesomeIcons.digitalOcean;
        break;
      default:
        return FontAwesomeIcons.accessibleIcon;
        break;
    }
  }
}