/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/packs/";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/reportrooms.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/reportrooms.js":
/*!*********************************************!*\
  !*** ./app/javascript/packs/reportrooms.js ***!
  \*********************************************/
/*! no static exports found */
/***/ (function(module, exports) {

ContentLoaded = function ContentLoaded(event) {
  SelectReport = function selectReport(_type) {
    document.location.href = "/reportrooms/type/" + _type;
  };

  ShowReport = function showReport(_type) {
    document.location.href = "/reportrooms/" + _type;
  };

  Vaildform = function vaildform(_event) {
    selectobj = document.getElementById('reportroom_type');
    contentobj = document.getElementById('reportroom_contents');
    plancontensobj = document.getElementById('reportroom_plancontents');

    if (selectobj.selectedIndex == 0) {
      alert("select type");
      return false;
    }

    if (contentobj.value.length < 1) {
      alert("check content");
      return false;
    }

    return true;
  }; // textarea key event


  TextareaKeydown = function TextareaKeydown(event) {
    var keycode = event.keyCode; // 탭 키

    if (keycode == 9) {
      event.preventDefault();
      textareaobj = document.getElementById(event.target.id);

      if (null == textareaobj) {
        return;
      }

      var valueStart = textareaobj.selectionStart;
      textareaobj.value = textareaobj.value.substring(0, textareaobj.selectionStart) + "\t" + textareaobj.value.substring(textareaobj.selectionEnd);
      textareaobj.selectionEnd = valueStart + 1;
    } // 엔터 키
    else if (keycode == 13) {
        event.stopPropagation();
      }
  };

  setTimeout(function () {
    alertobj = document.getElementById("alertmsg");

    if (alertobj) {
      alertobj.style.display = "none";
    }
  }, 3000); // 글 읽기 표시 처리

  {
    buttons = document.getElementsByClassName("btn collapsed");
    roomtypeobj = document.getElementById("roomtype");
    console.log(roomtypeobj); //console.log(buttons);

    if (null == roomtypeobj) {
      return;
    }

    roomtype = roomtypeobj.dataset.type;

    if (null == roomtype) {
      return;
    }

    if (null != buttons) {
      for (idx = 0; idx < buttons.length; ++idx) {
        /*
        				targetid = buttons[idx].dataset.target;
        				
        				frame  = document.getElementById(targetid.replace("#", ""));
        				if(null != frame)
        				{
        					try
        					{
        						frame.addEventListener('click', function() {
        							alert("ASDFAS");
        						});
        
        					}
        					catch(error)
        					{
        						console.error(error);
        					}
        						
        				}
        */
        $(buttons[idx].dataset.target).on('shown.bs.collapse', function (_event) {
          //document.location.href =  "/reportrooms/${buttons[idx].dataset.target.replace('#accordion')}";
          obj = _event['target'];

          if (null != obj) {
            targetid = obj.id;

            if (null != targetid) {
              id = targetid.replace('accordion', "");
              path = "/reportrooms/read";
              param = "type=".concat(roomtype, "&id=").concat(id); //document.location.href = path;

              httpRequest = new XMLHttpRequest();

              if (null == httpRequest) {
                alert("nil");
                return;
              }

              httpRequest.onreadystatechange = function () {
                if (this.readyState == this.DONE) {
                  console.log(this.status);

                  if (this.status != 200) {
                    return;
                  }

                  console.log(this.responseText);

                  try {
                    jobj = JSON.parse(this.responseText);
                    font = document.getElementById("font".concat(jobj.id));

                    if (null != font) {
                      font.style.color = "blue";
                    }
                  } catch (ex) {
                    console.log(ex);
                  }
                }
              };

              httpRequest.open('POST', path);
              httpRequest.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
              httpRequest.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
              httpRequest.send(param);
            }
          }
        });
      }
    }
  }
};

window.addEventListener("DOMContentLoaded", ContentLoaded);
window.addEventListener("unload", function (_event) {
  window.removeEventListener("DOMContentLoaded", ContentLoaded);
  console.log("unload");
});
/*
window.addEventListener("load", function(){
	alert("asdf232523asdf");
});
*/

/***/ })

/******/ });
//# sourceMappingURL=reportrooms-1e68dc5587bb6f59125d.js.map