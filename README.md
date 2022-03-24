# Collect-Texture-and-Rename-Material-Script

经常做美术资源的时候遇到一件很蛋疼的事情，外包发过来给的材质名字可能是瞎jb取的，比如各种 “asdsdsdsd”、 “lamert232323232”、 “zxzxzzzzz” 之类的怪名字。

但是呢，他的贴图又是一个正常的名字，于是乎这个场景包发给程序那边，就会发生一件很蛋疼的事情，程序完全不知道某个xjb取名的材质对应是哪张贴图。如下图这种六亲不认的材质名。

![image](https://github.com/DaiZiLing/Collect-Texture-and-Rename-Material-Script/blob/main/Images/0324_2.png)

所以场景规范一般会要求，“材质名和贴图名一致”，手动重命名材质比较蛋疼，于是我就整了这么一个脚本。

它包含了有max 2021以上及以下两个版本，左边的支持vray材质。它的主要功能是：将材质名称改成和贴图名称一致，并且还能顺带把散装在各个文件夹的贴图收集起来。

![image](https://github.com/DaiZiLing/Collect-Texture-and-Rename-Material-Script/blob/main/Images/0324_4.png)

使用这个脚本后，乱七八糟的材质名被改为贴图名，并且贴图（包括法线、漫反射、高光啥的）也被收集了。

![image](https://github.com/DaiZiLing/Collect-Texture-and-Rename-Material-Script/blob/main/Images/0324_1.gif)

![image](https://github.com/DaiZiLing/Collect-Texture-and-Rename-Material-Script/blob/main/Images/0324_3.png)

那么该如何使用呢？1、先点 “前处理” ；2、再点 “整理视口内贴图” 或者 “整理整个场景贴图” 就行啦 ~ 

后排提示：我写这个脚本的时候，其中的代码特别难看，使用了一万个罪孽深重的if else，不管他了能用就行，草草草
