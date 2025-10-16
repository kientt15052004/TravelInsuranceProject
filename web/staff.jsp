<%-- 
    Document   : staff
    Created on : Dec 8, 2024
    Author     : Staff Page
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - Hệ thống quản lý bảo hiểm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
  <body>
      <!-- Top Header -->
      <div class="top-header">
          <div class="header-left">
              <div class="logo">
                  <div class="logo-text">
                      <span class="logo-main">Logo</span>
                  </div>
              </div>
          </div>
          <div class="header-right">
              <div class="user-dropdown">
                  <div class="user-info">
                      <i class="fas fa-user-circle"></i>
                      <span>Staff</span>
                  </div>
                  <i class="fas fa-chevron-down dropdown-arrow"></i>
                  <div class="dropdown-menu">
                      <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                          <i class="fas fa-sign-out-alt"></i>
                          Đăng xuất
                      </a>
                  </div>
              </div>
          </div>
      </div>

      <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <nav class="sidebar-nav">
                <ul>
                    <li class="nav-item active">
                        <a href="${pageContext.request.contextPath}/staff" class="nav-link">
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/CreateContractServlet" class="nav-link">
                            <span>Tạo hợp đồng mới</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/ContractManagementServlet" class="nav-link">
                            <span>Quản lý hợp đồng</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/usermanagement" class="nav-link">
                            <span>Quản lý User</span>
                        </a>
                    </li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <!-- Empty footer for now -->
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1>Dashboard</h1>
                <p>Coming Soon</p>
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque augue ligula, ut varius turpis molestie et. Duis sed enim turpis. Curabitur at enim eget magna sodales scelerisque. Aliquam sed consectetur nisi, ut viverra urna. Ut sit amet porta diam. Etiam convallis, risus vel varius vestibulum, dui libero rutrum velit, nec auctor dolor tellus ut sem. Fusce quis gravida magna. Phasellus porta laoreet nunc, vel ultricies turpis eleifend vitae. Suspendisse ac ligula fringilla, tincidunt quam eu, commodo urna. Fusce a convallis dolor, id tincidunt est.

Maecenas efficitur congue enim sollicitudin faucibus. Donec convallis nec purus vel interdum. Pellentesque viverra, felis id ullamcorper luctus, erat mi tempus velit, in porttitor ante libero et leo. Etiam nec est ante. Curabitur lobortis tortor vel dapibus fringilla. Nunc vel mauris eget turpis gravida rutrum a eget dolor. In faucibus euismod ipsum porttitor consectetur. In neque nibh, tempor ac consequat id, sodales ut arcu. Ut leo mauris, mollis venenatis urna quis, porta commodo justo. Nullam mattis massa et risus consequat, quis sodales sapien bibendum. Morbi interdum nec tellus in maximus. Mauris id dignissim velit. Phasellus at malesuada diam. Aliquam pellentesque dolor tortor, et feugiat nulla interdum et.

In commodo hendrerit ante, eu dignissim ipsum suscipit suscipit. Mauris laoreet diam non nisi pulvinar ornare. Quisque placerat vitae sem vel dapibus. Maecenas dictum tortor quis mi luctus consectetur. Donec ante augue, pulvinar vel ultrices sed, finibus ut felis. Aliquam venenatis gravida mauris nec gravida. Nullam nec facilisis mi. Nunc commodo nulla nec ultricies faucibus. Suspendisse ultrices porttitor leo, et convallis diam tincidunt ac. Phasellus auctor magna vel dolor faucibus convallis. Vivamus enim magna, luctus nec venenatis lobortis, ullamcorper nec ipsum.

In iaculis volutpat arcu sit amet suscipit. Curabitur nulla ligula, tristique eu vestibulum a, gravida eu justo. Pellentesque mollis metus nec libero facilisis, sed vulputate quam convallis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus dignissim lectus quis leo vulputate, eu placerat lectus varius. Cras a rhoncus nibh. Phasellus auctor aliquet ligula, eu vehicula mi accumsan congue. Mauris lacus ligula, pulvinar sed tellus ac, interdum tincidunt neque. Pellentesque sollicitudin nisi magna, sed gravida mi ornare quis. Nullam tellus turpis, suscipit sit amet dignissim eu, pulvinar vel urna. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;

In pulvinar euismod nulla vel molestie. Duis imperdiet orci libero, eu interdum orci iaculis at. Vivamus lacus ligula, bibendum sed maximus id, gravida nec orci. Donec aliquam dapibus enim a gravida. Fusce id vehicula ante, ac sollicitudin magna. Nam tempus nulla quis posuere ultricies. Maecenas diam nibh, facilisis et tempus vel, gravida ut nisi. Fusce aliquet mollis lorem eu sodales. Praesent et sapien ante. Mauris elit urna, tempus id vulputate id, ultrices ut sem.

Donec eleifend neque fringilla eleifend faucibus. Mauris malesuada nulla id mattis lacinia. Integer purus sapien, vestibulum vitae mi eget, ultricies mollis tellus. Vivamus vel urna dapibus, placerat eros ac, suscipit mauris. Aliquam posuere ultrices feugiat. Praesent eu posuere tortor. Duis id mi at tortor fermentum tincidunt. Nunc auctor, lectus et pharetra scelerisque, mi nulla pretium sapien, et ultrices urna neque sed enim. Vestibulum dictum massa a leo fringilla, id vehicula tortor fringilla. Pellentesque pulvinar neque quis lectus facilisis ornare. Nam finibus nisi at tempus fermentum. Pellentesque congue commodo suscipit. Fusce ultricies mattis ex, ut elementum orci viverra id.

Maecenas nec arcu eget magna porta iaculis a in orci. Morbi eu elit tellus. Praesent a ligula libero. Mauris id imperdiet nunc. Aenean semper laoreet ipsum. Nullam ornare, nunc sit amet vulputate sodales, urna est hendrerit diam, a tristique diam dolor eu lacus. Ut efficitur ex turpis, vitae convallis magna tempor a. Duis maximus aliquet neque, quis faucibus massa pulvinar sit amet. Fusce dapibus, sem id pharetra dignissim, augue risus pharetra nisi, rhoncus consectetur urna justo interdum purus. Phasellus interdum ante at mi efficitur laoreet. Donec nec aliquam urna, vel vestibulum quam. Vivamus dapibus pellentesque faucibus. Suspendisse potenti. Ut et justo luctus, tempor sem id, elementum velit. Cras finibus nec metus sed auctor.

Morbi sed fermentum nulla. Vestibulum ornare nulla sed mauris egestas condimentum quis non arcu. Duis pulvinar, risus eu semper eleifend, ex sapien condimentum massa, id aliquam sapien lorem sed turpis. Mauris ullamcorper dui vel felis aliquam semper. Vivamus et eros tempus, ultrices purus vel, pulvinar sem. Nam imperdiet vitae mi sit amet ornare. Donec porttitor vehicula sollicitudin. Vestibulum eu lobortis quam, vel consequat magna. Maecenas non ex sodales, pulvinar sapien ut, sollicitudin massa.

Integer ornare euismod magna ut placerat. Proin maximus bibendum mi sit amet fringilla. Duis luctus lorem id dolor molestie rhoncus. Donec lobortis non sapien tempor placerat. Vestibulum tristique pretium accumsan. Curabitur eget enim eros. Fusce libero velit, scelerisque ut sem eu, ultrices maximus libero. Fusce vehicula augue lacus, non tempus sem maximus nec.

Nullam purus mi, interdum quis neque ultricies, placerat aliquet massa. Fusce vitae dolor quis nunc commodo placerat. Cras dolor nisi, congue nec vehicula eget, laoreet id turpis. Aenean ultrices ac neque a eleifend. Maecenas malesuada lectus id turpis faucibus lacinia non et urna. Maecenas sit amet turpis nisi. Morbi lacinia tincidunt felis id eleifend. Vestibulum non purus sit amet ligula feugiat pretium sit amet eu sem. Morbi sed urna leo. Pellentesque congue enim sit amet ex pellentesque, id feugiat urna eleifend. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Donec a sagittis quam. Nulla non dignissim mauris, at eleifend dolor.

Quisque cursus tristique felis. Duis sodales quam aliquam eros commodo, eget fermentum mauris gravida. Praesent quis ultricies purus, vitae congue ante. Integer luctus, elit convallis blandit tempor, ex ipsum feugiat lacus, at placerat felis libero sit amet felis. Fusce eros erat, ullamcorper eu rutrum id, sollicitudin id urna. Donec ac aliquet diam. Fusce pretium nunc eu mattis venenatis. In ac mi rutrum, commodo dui at, ornare quam.

Pellentesque pulvinar, sapien nec congue pretium, enim diam faucibus lacus, nec fringilla enim ipsum ut arcu. Donec aliquam, massa a interdum luctus, neque dui ullamcorper risus, in tincidunt lectus magna vitae tortor. Pellentesque nulla turpis, mattis nec sagittis eu, sodales ut nisi. Donec hendrerit ut dolor sed condimentum. Proin semper tristique augue, sit amet sagittis ligula consectetur vitae. Vestibulum vel suscipit quam, posuere eleifend nisl. Maecenas pellentesque risus vitae nibh placerat iaculis. In fringilla auctor augue sed consequat. Mauris fringilla magna nec vulputate pulvinar. Vivamus in euismod ante. Quisque iaculis risus id malesuada tincidunt. Donec ut pharetra quam. Cras luctus nulla eget faucibus tincidunt.

Ut risus lectus, elementum non luctus ac, luctus eget justo. Suspendisse a pellentesque libero. Proin cursus fringilla leo. Curabitur aliquet turpis in augue laoreet facilisis. In vitae dolor imperdiet, egestas tortor vitae, viverra mauris. Nunc in nisl at eros volutpat ullamcorper. Phasellus rhoncus dolor id purus fringilla tempus. Ut venenatis quam at nunc vehicula, sed ultrices neque ullamcorper. Fusce et risus pretium, mollis lorem vestibulum, ultricies nunc. Nulla facilisi. Phasellus interdum felis ac erat pulvinar euismod. In egestas nisi sit amet commodo aliquet. Donec ultricies varius neque quis venenatis.

Nulla a elementum magna. Fusce fermentum sed purus nec varius. Sed posuere sodales libero sagittis ullamcorper. In ac mollis tellus. Nulla facilisi. Donec in nibh dui. Suspendisse molestie nisl eu augue finibus, id porta enim auctor. Suspendisse eleifend turpis non orci consectetur, ut ornare dui finibus. Ut vestibulum quam vulputate, aliquet arcu ac, porta lectus. Nullam fringilla massa vitae ipsum dignissim, id mollis est pretium. Donec eleifend ex in odio varius eleifend.

Aenean a magna arcu. Maecenas pretium et sem at consequat. Donec ante eros, posuere ut mauris accumsan, vehicula pulvinar mi. In at dapibus est, vitae imperdiet tortor. Suspendisse potenti. Mauris rhoncus justo urna, et facilisis odio tincidunt vel. Donec sed sem velit. Donec convallis velit auctor, vestibulum turpis et, tincidunt lectus. Nam ut mi consectetur, sagittis purus consequat, pretium ante. Donec euismod commodo placerat. Proin diam dolor, egestas et lacus eu, ultricies consequat enim. Mauris blandit turpis leo, sit amet bibendum eros auctor vitae. Aenean nibh sapien, semper sit amet mollis scelerisque, lobortis a orci. Fusce diam purus, iaculis vel quam et, sodales sagittis sapien.

Proin ut commodo felis. Maecenas blandit sit amet lorem a euismod. Nam in urna sodales, pellentesque tellus vel, commodo quam. Aenean scelerisque eros ut magna tincidunt, eget condimentum nunc consequat. Suspendisse elementum rutrum lectus ac pretium. Suspendisse fermentum blandit neque id venenatis. Donec nisl libero, vulputate vitae urna eu, pharetra bibendum quam. Proin arcu tortor, imperdiet vitae volutpat eu, accumsan at erat. Proin elementum, sem at laoreet porta, felis urna vehicula ante, ac rutrum sapien nisl quis diam. Integer cursus nulla vitae dignissim tempus. Etiam nec magna vel magna consequat tristique a molestie urna. Ut ornare nibh purus.

Etiam fermentum id purus eget viverra. Nunc pellentesque dictum neque. Nulla convallis commodo urna, eget vestibulum orci maximus et. Sed feugiat hendrerit lacus, in dignissim ex. Vestibulum sagittis semper quam. Nunc orci metus, consequat vitae ipsum a, imperdiet lacinia tellus. Ut magna risus, tristique in placerat eget, volutpat quis nisl. Praesent varius cursus lorem, ut fringilla nunc tincidunt vitae. Etiam quis varius est, ac congue risus. Ut ac dapibus mauris. Praesent venenatis lectus odio, et iaculis dolor mollis et. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Aliquam tincidunt arcu ornare lacus lobortis, tincidunt rhoncus sem rhoncus. Morbi dignissim, massa sed porttitor hendrerit, leo arcu hendrerit felis, a faucibus nulla leo eget augue.

Ut vestibulum nec leo in gravida. In at velit sollicitudin, finibus tellus in, dictum felis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nam a tristique nunc, ac accumsan orci. Vestibulum fringilla accumsan ante id bibendum. Mauris vel aliquam ligula, et ultrices eros. Sed bibendum tempor tempor.

Aliquam iaculis id tellus eu feugiat. Donec vel lacus in purus fringilla vulputate pellentesque eu lacus. Nulla dolor lorem, porta eget facilisis sit amet, sollicitudin eget quam. Praesent ut elit fringilla, finibus mi sed, placerat mauris. Nunc eu consectetur quam, a ultricies sem. Nam pretium placerat elit, et vestibulum sapien semper sed. Quisque ut enim velit. Quisque magna orci, scelerisque eu elit in, tincidunt luctus dolor. In vitae eros fermentum, dapibus lacus ut, tincidunt neque. Pellentesque in ipsum in justo dignissim malesuada. Duis placerat massa nisi, quis pulvinar est dignissim aliquet.

Mauris blandit imperdiet nibh, elementum ultricies felis vehicula non. Donec ultricies leo gravida fringilla lacinia. Pellentesque sodales commodo velit, at faucibus ligula condimentum vel. Integer in felis in nibh luctus elementum eu eu dui. Vestibulum quis dictum augue. Phasellus eget laoreet massa. In hac habitasse platea dictumst. Suspendisse placerat vestibulum interdum. Morbi dictum pharetra purus, vitae rutrum tortor iaculis ac.

Suspendisse metus mauris, tincidunt finibus interdum sit amet, facilisis vitae enim. Aliquam nec mauris ut sapien commodo aliquam ac nec nulla. Fusce vestibulum turpis ut ligula suscipit, eu pulvinar metus interdum. Suspendisse elit turpis, aliquet sit amet pulvinar a, porttitor eu sapien. Ut venenatis accumsan diam facilisis iaculis. Aliquam non facilisis mauris, vitae pellentesque diam. Maecenas mattis ligula at tempor tristique. Nulla diam tellus, iaculis ut nunc quis, porta tempus massa. Etiam sed dolor tortor. Maecenas volutpat lectus sapien, fringilla aliquet elit mattis nec.

Donec interdum turpis nisl, id aliquam quam dignissim sed. Aliquam in rutrum magna. Curabitur tempor, orci id blandit auctor, lacus turpis convallis sem, eget laoreet justo felis vel dui. Maecenas dictum fringilla iaculis. Aenean bibendum quis ipsum at hendrerit. Fusce nec turpis eu tellus porta efficitur quis at ante. Suspendisse volutpat varius tempor. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vestibulum dignissim pharetra quam non faucibus. Phasellus vitae nisi at tortor luctus hendrerit. Aliquam venenatis eros quam, auctor interdum urna porttitor luctus. Aliquam luctus tempus augue. Nulla facilisi. Etiam eu ultrices tellus. Nulla mollis condimentum erat vitae euismod. Aliquam venenatis orci turpis, eget ultrices nulla efficitur et.

Vestibulum posuere nibh non eros elementum, non hendrerit mauris cursus. Quisque commodo magna vehicula vehicula gravida. Etiam quis pellentesque nisl. Nulla tincidunt posuere erat, ut venenatis lacus finibus vel. Quisque sit amet lobortis sapien, ac tempus neque. Maecenas pharetra ipsum nec erat ornare, at pellentesque ipsum tempus. Nulla pharetra lacus tellus, nec sagittis nisi elementum quis. Pellentesque suscipit ultrices lacus in sodales. Curabitur vel tempor leo. Donec elementum enim nibh, et pellentesque libero vestibulum id. Morbi ipsum purus, mollis eleifend libero vel, porttitor elementum odio. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.

Morbi ante dui, sollicitudin non elit pretium, commodo bibendum felis. Vestibulum sodales risus magna, vitae molestie libero gravida a. Donec semper erat eu laoreet vestibulum. Donec interdum risus tellus. Sed id ipsum in leo imperdiet efficitur. Maecenas nec faucibus justo, condimentum mattis tellus. Aenean facilisis velit quis turpis hendrerit malesuada. In pretium, tellus a blandit gravida, ipsum libero tincidunt ipsum, eu accumsan lacus nunc nec dolor. Nam molestie faucibus nulla ut iaculis.

Vivamus dapibus ornare augue. Donec at nunc ligula. Cras ipsum ante, bibendum eu mauris sit amet, consequat rutrum odio. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aenean id quam lacinia, consequat odio vitae, eleifend turpis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Donec gravida sapien neque, vitae placerat enim sagittis vitae. Ut venenatis fermentum dolor a iaculis. Nam vel pretium arcu. Morbi vel lacus odio. Praesent urna ante, efficitur vel enim molestie, lacinia dapibus arcu. Nullam tristique quis leo vel euismod. Sed commodo elit non lacus rhoncus, scelerisque vestibulum nunc sodales.

Donec id sapien dui. Maecenas ornare elementum nisi, et rhoncus lectus scelerisque pharetra. Phasellus magna tortor, malesuada et dictum eget, accumsan nec felis. Integer laoreet nisi at velit posuere faucibus. Vivamus felis justo, pulvinar vel fringilla non, ultricies in urna. Proin a metus vitae justo mollis pretium. Nullam nisi tellus, tincidunt eu fringilla vitae, porttitor sit amet ligula. Cras eu augue lectus. Cras gravida nisl sed purus ornare, ac mattis tortor ornare.

Aliquam erat volutpat. Nam tellus magna, pellentesque sed efficitur sed, dapibus in velit. Vestibulum in felis ex. Vestibulum imperdiet mattis eros vitae rutrum. Donec ornare, justo interdum tincidunt rutrum, lacus est luctus nibh, a sollicitudin turpis ante quis ante. Integer nisl lectus, aliquet et dolor efficitur, facilisis tristique quam. In sit amet convallis magna. Sed at nunc in risus malesuada fringilla. Ut elit massa, porttitor non massa eget, pulvinar sagittis diam. Curabitur eu arcu eget urna rutrum eleifend venenatis sed metus. Donec hendrerit enim augue, a blandit eros auctor sed. Aenean et semper nisl. Phasellus ac lobortis lacus, et imperdiet nunc.

Maecenas sit amet massa in lacus tempor dapibus quis a nisi. Pellentesque efficitur risus et libero molestie, at faucibus sem porta. Mauris at laoreet enim. Praesent congue turpis at urna porttitor, vel blandit dolor pharetra. Maecenas sem nibh, volutpat ut felis id, pellentesque iaculis risus. Suspendisse potenti. Aenean ante ipsum, tincidunt ac tellus a, accumsan consequat dolor. In at pulvinar urna, at placerat mauris. Nam tincidunt ligula quis diam tristique venenatis. Quisque tempor aliquam nisi vel fringilla. Nullam ut eleifend lectus, id sagittis metus. Morbi placerat malesuada urna pulvinar congue. Pellentesque sit amet est vitae lacus suscipit interdum.

Donec fringilla tincidunt aliquet. Ut sed accumsan felis. Cras nec varius nisl, quis tincidunt neque. Proin elit ante, iaculis non congue quis, volutpat lacinia tortor. Mauris vel nisl turpis. Integer quis purus eu diam porttitor porttitor. Ut quis commodo nulla, vitae tincidunt nulla. Morbi euismod suscipit leo, accumsan euismod elit. Nam non sem at libero vehicula fermentum. Sed cursus eleifend enim, eget imperdiet nulla dignissim sit amet. Cras eleifend tincidunt eros ut consequat. Integer maximus eget velit eu tincidunt. Pellentesque pulvinar est ipsum, eu porta lacus tristique at. Donec porttitor placerat odio vel iaculis. Nulla finibus auctor erat, a facilisis lectus tempus eget. Suspendisse potenti.

Nullam a enim condimentum, viverra mauris vitae, mollis libero. Nulla metus mauris, sodales id condimentum non, tristique sit amet ligula. Phasellus ac magna ac leo mollis dignissim. Aliquam pulvinar velit et ultricies varius. Nunc eget eleifend mi. In sit amet ultrices ligula, nec pellentesque felis. Proin a sodales elit, at mattis tellus. In hac habitasse platea dictumst. Suspendisse tincidunt augue eget nulla auctor pretium. Donec ultrices pretium turpis, et euismod leo semper id.

In ullamcorper commodo turpis in vulputate. Quisque vestibulum vestibulum quam, tristique ullamcorper risus mollis sed. In sit amet efficitur mauris, vel bibendum leo. Nulla iaculis lectus nunc, nec varius enim condimentum non. Nulla facilisi. Quisque faucibus, neque sit amet tincidunt congue, lectus massa semper velit, nec eleifend neque elit condimentum sapien. Ut ullamcorper neque in scelerisque imperdiet. Pellentesque quis iaculis sapien, eu facilisis ante. Aenean urna risus, finibus id ipsum at, facilisis convallis magna. Nullam tempor augue mi, in vestibulum mi vehicula at. Quisque auctor arcu at risus elementum ultrices. Vivamus fermentum sapien tortor, gravida porta justo fermentum at. Ut ac turpis in libero semper euismod sit amet ut turpis.

Donec congue varius eleifend. Etiam vitae tortor imperdiet, molestie nulla vitae, porttitor sem. Aliquam sapien erat, iaculis nec dignissim ut, accumsan nec magna. Proin venenatis scelerisque velit sit amet tempor. Aliquam sed ex nec elit congue iaculis eu eu eros. Curabitur eget urna sit amet quam euismod molestie. Vivamus dapibus, nisl a fringilla iaculis, metus est pretium justo, vel tempor nibh purus eget mi. Mauris a tortor ut sapien varius tempus. Fusce porta et erat quis hendrerit.

Pellentesque urna felis, dignissim in lacinia non, mattis non leo. Sed quis placerat elit, id mattis nibh. Curabitur eu eleifend lorem. Cras bibendum leo non scelerisque lobortis. Proin vestibulum, dui et vehicula volutpat, lacus quam viverra nulla, ut cursus sem ex et quam. Nulla accumsan vulputate iaculis. Aliquam cursus et lectus vitae convallis. Quisque molestie dictum dui vitae sodales. Vivamus dapibus vestibulum pulvinar. Pellentesque euismod convallis odio id lacinia. Sed viverra neque ac enim rutrum blandit.

Suspendisse ut enim ac elit iaculis euismod sit amet vitae felis. Mauris augue neque, consequat vel orci a, pretium pharetra est. Vestibulum in aliquet nunc. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam fermentum, magna at mattis tempus, urna nulla tristique ex, sed tincidunt justo ex sed lacus. Maecenas in posuere dui, id accumsan purus. Vivamus convallis felis dapibus est rutrum, porta vehicula neque pharetra. Suspendisse potenti. Praesent semper mauris a nulla posuere, id malesuada odio mollis. Praesent scelerisque, mauris quis interdum varius, purus risus dignissim dolor, non aliquam lacus lacus ut enim.

Phasellus tincidunt dictum eros, nec vestibulum felis interdum ut. In sed dui lorem. Proin dictum urna nulla. Suspendisse hendrerit suscipit purus ac interdum. Mauris rutrum orci sapien, et ultrices mi dictum id. Etiam non ligula nec nisl convallis suscipit et ut dui. Mauris eleifend lectus sed urna rhoncus, sit amet condimentum massa laoreet. Sed vehicula luctus molestie. Mauris cursus sed metus eu congue. Donec eget sem eu ligula pellentesque volutpat ut nec ante. Maecenas efficitur consectetur nibh, sed viverra risus porttitor eu.

Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus sollicitudin egestas diam. Vivamus rhoncus quam sit amet turpis faucibus sagittis. Nunc sollicitudin iaculis neque a ullamcorper. Sed nibh mi, pellentesque in dui at, facilisis ultrices tortor. Nullam quis lorem ligula. Suspendisse justo sapien, euismod ac velit at, lobortis eleifend libero. Maecenas cursus eros feugiat nibh ornare molestie. Nulla facilisi. Duis tempus ut elit id maximus. Cras sodales, nisi vitae dapibus efficitur, ex magna faucibus ante, vitae tempus quam magna ut mi. Aenean efficitur semper neque, vitae sollicitudin mi suscipit quis.

In eu fringilla neque, sit amet faucibus magna. Curabitur dapibus a erat et ultricies. Fusce porta elit sit amet malesuada scelerisque. Vivamus gravida nec est nec accumsan. Curabitur semper est ex, vel elementum metus sagittis eget. Pellentesque tempus, risus eu bibendum efficitur, nunc odio suscipit massa, id volutpat purus elit eget metus. Sed eget feugiat nisl. Pellentesque suscipit quam est. Donec et ipsum sed tortor vehicula porta et a magna. Vivamus ornare, quam a vehicula faucibus, nulla dolor feugiat felis, nec dictum lorem lorem ultrices turpis. Morbi tellus massa, hendrerit sed mollis ut, vulputate quis lacus. Proin dolor risus, pulvinar vitae dignissim a, auctor in neque.

Vivamus semper purus nec orci venenatis consectetur. Donec faucibus nec nisl nec condimentum. In at mi vitae felis molestie varius. Cras vestibulum viverra ultrices. In tincidunt mi nec eros lacinia feugiat. Cras porta lorem vel lacus faucibus, molestie malesuada nisi pharetra. Curabitur euismod eget nunc vitae cursus.

Cras ac facilisis dui, sit amet vehicula nisi. Nullam malesuada volutpat urna, eget consequat ante aliquet at. Maecenas dignissim congue nisl sed lobortis. Nam vitae ante ut ipsum cursus finibus. Morbi at nisl nulla. Nunc maximus consequat ligula, fermentum facilisis metus gravida sit amet. Nam posuere in lorem non dictum. Fusce sollicitudin scelerisque molestie. Vivamus pellentesque augue in vulputate sodales. Curabitur maximus massa nec egestas sodales. Sed commodo velit ut mi tincidunt gravida. Vestibulum rutrum ultricies arcu at commodo. Curabitur ultrices, velit quis interdum vehicula, neque erat mollis urna, et ultricies libero odio non est.

Phasellus sit amet felis eget leo aliquam scelerisque. Aliquam a pharetra est, vel aliquam purus. Maecenas faucibus gravida velit, vel faucibus tellus volutpat et. Sed lorem felis, dictum et dui sit amet, vestibulum interdum nisi. In blandit dolor ipsum, et gravida quam consectetur vitae. Cras malesuada, ex maximus egestas auctor, enim dolor luctus ex, at rutrum tellus neque vel nunc. Duis at leo magna. Nullam et auctor elit.

Proin tempus ante non ex commodo, eget varius augue pretium. Suspendisse potenti. Donec in ultricies est, non porta arcu. Nullam sollicitudin erat ante, vitae cursus orci egestas id. Etiam eleifend consectetur sollicitudin. Mauris facilisis ex a justo ullamcorper, ut pulvinar metus tempus. Vivamus quis luctus turpis. Donec tempus leo at augue fermentum fermentum. Nunc volutpat purus et fringilla mollis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Duis dignissim, ante vitae faucibus imperdiet, massa tortor semper leo, in semper sem sem id sapien. In mollis luctus mi, aliquet tempor lorem convallis in. Cras ultricies nec nunc quis fermentum. Praesent faucibus neque ut pretium gravida.

Nunc pellentesque ipsum sapien, vel auctor lacus viverra aliquam. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Cras gravida urna ac enim laoreet ultricies. Donec venenatis dictum blandit. Nunc maximus tincidunt nisl et mattis. Proin facilisis convallis velit ut vehicula. Curabitur dui ligula, accumsan sit amet diam non, condimentum tempus nisi. Sed nec felis iaculis, pharetra lectus ac, gravida sapien. Aliquam et interdum nunc, vitae ullamcorper sem. Aliquam a tempor lectus. Duis pharetra suscipit rutrum. Ut consequat congue felis, id cursus orci. Mauris semper nisi justo, ut elementum libero molestie non. Nam congue sodales neque a porttitor.

Praesent vel dolor at arcu euismod tincidunt. Nullam finibus convallis justo ut rutrum. Cras porta rhoncus nunc. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Ut pretium lacus accumsan turpis commodo sagittis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur auctor, sapien eu ultrices aliquet, ligula augue faucibus nunc, et volutpat ligula purus eu urna. Proin augue mauris, suscipit non justo id, tempor tempus enim. Etiam sodales massa nec diam porttitor, et accumsan leo convallis. Proin pellentesque lorem non finibus fermentum. Vivamus a orci lobortis, aliquam magna ac, pulvinar nisl. Aliquam viverra diam non ex auctor lobortis. Donec nec tristique nulla. Sed non dolor molestie, vulputate enim eget, accumsan tortor.

In at viverra sapien. Vestibulum placerat viverra blandit. Ut in magna dolor. Etiam nec ligula tortor. Nullam et pulvinar mi, id porta magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin ut ipsum ac lorem accumsan tincidunt vitae in enim. Sed vel ipsum magna.

Duis leo augue, feugiat vitae est id, tincidunt cursus erat. Nulla sollicitudin nec sapien vitae egestas. Morbi iaculis, velit varius vestibulum maximus, orci ligula cursus ligula, convallis convallis lacus nunc eu magna. Vivamus tincidunt elit quis nibh sollicitudin, euismod sagittis est ornare. Nulla facilisi. Sed mollis convallis nisl. Praesent vulputate scelerisque enim, ac viverra tellus placerat ut.

Quisque a magna rutrum mauris egestas sagittis. Praesent ut augue malesuada, malesuada orci at, tristique nunc. Integer aliquam aliquam turpis. Nam dictum, risus non commodo ullamcorper, libero enim imperdiet mauris, non luctus lectus libero id nulla. Donec ut est sed diam sagittis bibendum. Nunc non aliquam magna. Nulla facilisi. Nulla porttitor, enim sed faucibus porta, dui neque ullamcorper sapien, ac cursus felis dui eu justo. Aliquam efficitur quis ante in ullamcorper. Nullam vitae turpis convallis, mattis enim at, condimentum augue. Duis et ante tempor, dictum lectus ut, semper orci.

Duis tincidunt, sem sed blandit malesuada, mi ex egestas eros, eget ultrices sapien purus ut leo. Quisque condimentum lorem ut enim gravida, non mollis diam tempor. Sed aliquam tortor eget velit feugiat varius. Quisque sit amet est purus. Vestibulum bibendum vitae lectus eget consequat. Sed sit amet ullamcorper risus. Morbi sollicitudin ultrices placerat. Integer mi risus, fermentum sed scelerisque commodo, finibus at turpis. Nunc porttitor lobortis odio, eu cursus justo pellentesque ut. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam nec sodales risus. Cras ut vestibulum ante. Nullam eu nisi ac turpis condimentum rutrum nec sit amet erat.

Duis tempus nisi sollicitudin elit sagittis suscipit. Praesent ac velit id est finibus consequat ut in est. Aliquam eget vehicula libero. Sed aliquam ullamcorper felis, nec auctor nibh consectetur vitae. Fusce consectetur consequat interdum. Nunc vulputate non mauris eget suscipit. Ut suscipit fringilla tellus in eleifend.

Phasellus a rutrum erat. Vivamus laoreet fermentum tincidunt. Curabitur rhoncus sagittis metus a pretium. Nam pulvinar metus sit amet nunc convallis convallis. Integer imperdiet pharetra malesuada. Maecenas vulputate magna sapien, et commodo sem suscipit id. Praesent id lorem sit amet ex molestie sagittis ac et ligula. Nam condimentum purus a mi rutrum laoreet.

Ut ut commodo nibh, non tempor augue. Ut vehicula fringilla purus, non condimentum quam gravida et. Suspendisse eu ipsum justo. Sed quis lorem quis erat pharetra sollicitudin. Curabitur vehicula lacus sit amet leo vehicula vehicula. Integer imperdiet leo risus, non convallis elit faucibus ultrices. Maecenas eleifend sed felis in semper. Sed sit amet ultricies mauris. Proin fermentum cursus lacus, malesuada mattis ante cursus blandit. Nulla nec neque ex. Cras et erat et tellus sodales tempor luctus et justo. Suspendisse efficitur magna ut accumsan cursus. Donec ante nisl, tempor sit amet egestas nec, tristique quis libero. Nulla facilisi. Integer ante erat, malesuada vel accumsan ut, lacinia sed metus.</p>
            </div>
        </div>
    </div>
</body>
</html>
