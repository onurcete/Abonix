import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Tanımlı bir markanın varlık yolları (SVG tercih edilir, yoksa PNG).
class BrandLogoPaths {
  const BrandLogoPaths({this.svg, this.png, this.jpeg});
  final String? svg;
  final String? png;
  final String? jpeg;
}

class BrandAssets {
  static const List<String> popularNames = [
    'Apple',
    'Apple Music',
    'Bumble',
    'ChatGPT',
    'Claude',
    'Disney+',
    'Dropbox',
    'Exxen',
    'Grok',
    'HBO',
    'Netflix',
    'PlayStation',
    'Spotify',
    'Tinder',
    'Xbox',
    'YouTube',
  ];

  static const Map<String, BrandLogoPaths> _logos = {
    'apple': BrandLogoPaths(svg: 'assets/brands/svg/apple.svg', png: 'assets/brands/png/apple.png'),
    'applemusic': BrandLogoPaths(
      svg: 'assets/brands/svg/applemusic.svg',
      png: 'assets/brands/png/applemusic.png',
    ),
    'bumble': BrandLogoPaths(svg: 'assets/brands/svg/bumble.svg'),
    'chatgpt': BrandLogoPaths(svg: 'assets/brands/svg/chatgpt.svg', png: 'assets/brands/png/chatgpt.png'),
    'claude': BrandLogoPaths(svg: 'assets/brands/svg/claude.svg', png: 'assets/brands/png/claude.png'),
    'disney': BrandLogoPaths(svg: 'assets/brands/svg/disney.svg', png: 'assets/brands/png/disney.png'),
    'disneyplus': BrandLogoPaths(svg: 'assets/brands/svg/disney.svg', png: 'assets/brands/png/disney.png'),
    'dropbox': BrandLogoPaths(svg: 'assets/brands/svg/dropbox.svg', png: 'assets/brands/png/dropbox.png'),
    'exxen': BrandLogoPaths(svg: 'assets/brands/svg/exxen.svg'),
    'grok': BrandLogoPaths(svg: 'assets/brands/svg/grok.svg', png: 'assets/brands/png/grok.png'),
    'gain': BrandLogoPaths(jpeg: 'assets/brands/jpeg/gain.jpeg'),
    'hbo': BrandLogoPaths(svg: 'assets/brands/svg/hbo.svg', png: 'assets/brands/png/hbo.png'),
    'hbomax': BrandLogoPaths(svg: 'assets/brands/svg/hbo.svg', png: 'assets/brands/png/hbo.png'),
    'netflix': BrandLogoPaths(svg: 'assets/brands/svg/netflix.svg', png: 'assets/brands/png/netflix.png'),
    'playstation': BrandLogoPaths(svg: 'assets/brands/svg/playstation.svg'),
    'ps': BrandLogoPaths(svg: 'assets/brands/svg/playstation.svg'),
    'psplus': BrandLogoPaths(svg: 'assets/brands/svg/playstation.svg'),
    'spotify': BrandLogoPaths(svg: 'assets/brands/svg/spotify.svg', png: 'assets/brands/png/spotify.png'),
    'tinder': BrandLogoPaths(svg: 'assets/brands/svg/tinder.svg', png: 'assets/brands/png/tinder.png'),
    'xbox': BrandLogoPaths(svg: 'assets/brands/svg/xbox.svg'),
    'xboxgamepass': BrandLogoPaths(svg: 'assets/brands/svg/xbox.svg'),
    'youtube': BrandLogoPaths(svg: 'assets/brands/svg/youtube.svg', png: 'assets/brands/png/youtube.png'),
  };

  static String normalize(String value) {
    var v = value.toLowerCase().trim();
    v = v.replaceAll(RegExp(r'[^a-z0-9]+'), '');
    if (v.contains('youtubepremium')) return 'youtube';
    if (v == 'hbomax' || v == 'max') return 'hbo';
    return v;
  }

  static BrandLogoPaths? pathsForName(String name) => _logos[normalize(name)];

  static String? forName(String name) {
    final p = pathsForName(name);
    if (p == null) return null;
    return p.svg ?? p.png ?? p.jpeg;
  }

  static List<String> startsWith(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return popularNames;
    return popularNames.where((name) => name.toLowerCase().startsWith(q)).toList();
  }

  /// Çerçevesiz marka görseli (form üstü gibi); SVG varsa onu, yoksa PNG.
  static Widget logoImageForName(
    String name, {
    required double size,
    BoxFit fit = BoxFit.contain,
  }) {
    final paths = _logos[normalize(name)];
    if (paths == null) return SizedBox(width: size, height: size);
    final svgPath = paths.svg;
    final pngPath = paths.png;
    final jpegPath = paths.jpeg;
    if (svgPath != null) {
      return SvgPicture.asset(svgPath, fit: fit, width: size, height: size);
    }
    if (pngPath != null) {
      return Image.asset(pngPath, fit: fit, width: size, height: size);
    }
    if (jpegPath != null) {
      return Image.asset(jpegPath, fit: fit, width: size, height: size);
    }
    return SizedBox(width: size, height: size);
  }

  static Widget logoOrFallback({
    required String name,
    required double size,
    Color fallbackBg = const Color(0xFFEAF1EC),
    Color fallbackFg = const Color(0xFF466557),
  }) {
    final paths = _logos[normalize(name)];
    if (paths == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: fallbackBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.apps_rounded, size: size * 0.62, color: fallbackFg),
      );
    }

    final svgPath = paths.svg;
    final pngPath = paths.png;
    final jpegPath = paths.jpeg;
    Widget child;
    if (svgPath != null) {
      child = SvgPicture.asset(svgPath, fit: BoxFit.contain);
    } else if (pngPath != null) {
      child = Image.asset(pngPath, fit: BoxFit.contain);
    } else if (jpegPath != null) {
      child = Image.asset(jpegPath, fit: BoxFit.contain);
    } else {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: fallbackBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.apps_rounded, size: size * 0.62, color: fallbackFg),
      );
    }

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEBEEEF)),
      ),
      child: child,
    );
  }
}
