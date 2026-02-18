function imgOut = insertText_java(imgIn, posXY, str, fontSize, textRGB, boxRGB, boxAlpha)
% posXY: [x y] where x=col, y=row (same as usual image coords)

if nargin < 7 || isempty(boxAlpha), boxAlpha = 0.6; end
boxAlpha = max(0, min(1, boxAlpha));

if isstring(str), str = char(str); end
if nargin < 4 || isempty(fontSize), fontSize = 12; end
if nargin < 5 || isempty(textRGB), textRGB = [255 255 255]; end
if nargin < 6, boxRGB = [0 0 0]; end

if ~usejava('jvm')
    error('insertText_java requires JVM. Do not run MATLAB with -nojvm.');
end

imgIn = uint8(imgIn);
H = size(imgIn,1); W = size(imgIn,2);

% MATLAB RGB -> Java ARGB int
R = int32(imgIn(:,:,1));
G = int32(imgIn(:,:,2));
B = int32(imgIn(:,:,3));
A = int32(255);
argb = bitshift(A,24) + bitshift(R,16) + bitshift(G,8) + B;
argb = argb';  % for Java

jImg = java.awt.image.BufferedImage(W, H, java.awt.image.BufferedImage.TYPE_INT_ARGB);
jImg.setRGB(0, 0, W, H, argb(:), 0, W);

g2 = jImg.createGraphics();
g2.setRenderingHint(java.awt.RenderingHints.KEY_TEXT_ANTIALIASING, ...
                    java.awt.RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

font = java.awt.Font('SansSerif', java.awt.Font.PLAIN, int32(fontSize));
g2.setFont(font);
fm = g2.getFontMetrics();

x = int32(posXY(1));  % col
y = int32(posXY(2));  % row
x = max(int32(1), min(int32(W-1), x));
y = max(int32(1), min(int32(H-1), y));

textW = int32(fm.stringWidth(str));
textH = int32(fm.getHeight());
ascent = int32(fm.getAscent());
pad = int32(2);

% background box
if ~isempty(boxRGB)
    bx = x; by = y;
    bw = textW + 2*pad;
    bh = textH + 2*pad;
    if bx + bw > W, bx = max(int32(1), W - bw); end
    if by + bh > H, by = max(int32(1), H - bh); end
    g2.setColor(java.awt.Color(boxRGB(1)/255, boxRGB(2)/255, boxRGB(3)/255, boxAlpha));
    g2.fillRect(bx-1, by-1, bw, bh);
    x = bx + pad;
    y = by + pad;
else
    x = x + pad;
    y = y + pad;
end

g2.setColor(java.awt.Color(textRGB(1)/255, textRGB(2)/255, textRGB(3)/255));
g2.drawString(str, x-1, y-1 + ascent);
g2.dispose();

out = jImg.getRGB(0, 0, W, H, [], 0, W);
out = reshape(out, [W, H])';

imgOut = zeros(H, W, 3, 'uint8');
imgOut(:,:,1) = uint8(bitand(bitshift(out, -16), 255));
imgOut(:,:,2) = uint8(bitand(bitshift(out, -8), 255));
imgOut(:,:,3) = uint8(bitand(out, 255));
end
