// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let DIMENSION = 25;
let PIXELSIZE = 2;
let REPEATSX = 20;
let REPEATSY = 15;

function drawGrid(canvas, ctx) {
  let canvasWidth = DIMENSION * REPEATSX * PIXELSIZE;
  let canvasHeight = DIMENSION * REPEATSY * PIXELSIZE;
  let selectedBox = null;

  canvas.attr("width", canvasWidth);
  canvas.attr("height", canvasHeight);

  // Draw grid.
  ctx.strokeStyle = '#cccccc';
  for (let i = 0; i < DIMENSION * REPEATSX; ++i) {
    if (i % DIMENSION != 0) { continue; }
    let x = i * PIXELSIZE;
    ctx.beginPath();
    ctx.moveTo(x, 0);
    ctx.lineTo(x, canvasHeight);
    ctx.stroke();

    let y = i * PIXELSIZE;
    ctx.beginPath();
    ctx.moveTo(0, y);
    ctx.lineTo(canvasWidth, y);
    ctx.stroke();
  }

  // Canvas Behaviors.
  canvas.click(function (e) {
    selectBox(e);
  });
  canvas.mousemove(function (e) {
    let pixel = [Math.floor(e.offsetX / (PIXELSIZE * DIMENSION)), Math.floor(e.offsetY / (PIXELSIZE * DIMENSION))];
    if (pixel[0] < 0 || pixel[1] < 0 ||
      pixel[0] >= REPEATSX || pixel[1] >= REPEATSY) {
      return;
    }
    if (!selectedBox) {
      selectedBox = $("<div id=selectedBox></div");
      selectedBox.css({ width: DIMENSION * PIXELSIZE - 2, height: DIMENSION * PIXELSIZE - 2 });
      $("#mycanvasWrapper").prepend(selectedBox);
    }
    selectedBox.css({
      left: pixel[0] * PIXELSIZE * DIMENSION + 1,
      top: pixel[1] * PIXELSIZE * DIMENSION
    });
  });

  let SELECTED = 0;
  function selectBox(e) {
    if (SELECTED) return;
    SELECTED = 1;

    let pixel = [Math.floor(e.offsetX / (PIXELSIZE * DIMENSION)), Math.floor(e.offsetY / (PIXELSIZE * DIMENSION))];
    window.location = "draw?x=" + pixel[0] + "&y=" + pixel[1];
  }

  let tiles = JSON.parse($("#mycanvaswrapper").get(0).dataset.tiles);
  fillGrid(ctx, tiles);
}

function fillGrid(ctx, tileData) {
  for (const [key, json] of Object.entries(tileData)) {
    let coord = key.split(",");
    let pixelData = JSON.parse(json);
    clearGrid(ctx, coord);
    for (let subkey in pixelData) {
      let subcoord = subkey.split(",");
      let color = pixelData[subkey];
      if (color == '#2') color = '#222244'; // hack to save some space on encoding.

      fillPixel(ctx, coord, subcoord, color);
    }
  }
}

function clearGrid(ctx, coord) {
  let coordX = parseInt(coord[0]);
  let coordY = parseInt(coord[1]);
  ctx.fillStyle = '#ffffff';
  ctx.fillRect(coordX * DIMENSION * PIXELSIZE, coordY * DIMENSION * PIXELSIZE,
    PIXELSIZE * DIMENSION, PIXELSIZE * DIMENSION);
  ctx.fillStyle = '#cccccc';
  ctx.strokeRect(coordX * DIMENSION * PIXELSIZE, coordY * DIMENSION * PIXELSIZE,
    PIXELSIZE * DIMENSION, PIXELSIZE * DIMENSION);
}

function fillPixel(ctx, coord, subcoord, color) {
  let coordX = parseInt(coord[0]);
  let coordY = parseInt(coord[1]);
  let subCoordX = parseInt(subcoord[0]);
  let subCoordY = parseInt(subcoord[1]);
  if (coordX < 0 || coordY < 0 ||
    coordX >= REPEATSX || coordY >= REPEATSY ||
    subCoordX < 0 || subCoordX >= DIMENSION ||
    subCoordY < 0 || subCoordY >= DIMENSION) {
    return;
  }

  ctx.fillStyle = color;
  let x = (coordX * DIMENSION + subCoordX) * PIXELSIZE;
  let y = (coordY * DIMENSION + subCoordY) * PIXELSIZE;
  ctx.fillRect(x, y, PIXELSIZE, PIXELSIZE);
}

let hooks = {
  canvas: {
    mounted() {
      console.log('mounted');
    
      let canvas = $("#mycanvas");
      let ctx = canvas.get(0).getContext("2d");

      drawGrid(canvas, ctx);

      Object.assign(this, { canvas, ctx });
    },
    updated() {
      console.log('updated');

      let { canvas, ctx } = this;

      drawGrid(canvas, ctx);
      //let tiles = JSON.parse($("#mycanvaswrapper").get(0).dataset.tiles);

      //fillGrid(ctx, tiles);
    }
  }
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: hooks});

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket