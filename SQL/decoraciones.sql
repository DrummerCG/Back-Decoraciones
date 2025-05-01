-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 08-03-2025 a las 05:27:34
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

USE `decoraciones`;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `decoraciones`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `administrador`
--

DROP TABLE IF EXISTS `administrador`;

CREATE TABLE `administrador` (
  `Id` int(30) NOT NULL,
  `ID_Contacto` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carrito_compras`
--

DROP TABLE IF EXISTS `carrito_compras`;

CREATE TABLE `carrito_compras` (
  `Id` int(30) NOT NULL,
  `Producto` varchar(100) NOT NULL,
  `Fecha_Creacion` datetime(6) NOT NULL,
  `Cantidad` varchar(100) NOT NULL,
  `ID_Productos` int(100) NOT NULL,
  `ID_Pedidos` int(11) NOT NULL,
  `ID_Inventario` int(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

DROP TABLE IF EXISTS `categoria`;

CREATE TABLE `categoria` (
  `id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id`) VALUES
('baño'),
('hogar');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria_y_producto`
--

DROP TABLE IF EXISTS `categoria_y_producto`;

CREATE TABLE `categoria_y_producto` (
  `ID_Productos` int(15) NOT NULL,
  `ID_Categoria` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria_y_producto`
--

INSERT INTO `categoria_y_producto` (`ID_Productos`, `ID_Categoria`) VALUES
(1, 'baño'),
(1, 'hogar');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

DROP TABLE IF EXISTS `cliente`;

CREATE TABLE `cliente` (
  `Id` int(15) NOT NULL,
  `ID_Contacto` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contacto`
--

DROP TABLE IF EXISTS `contacto`;

CREATE TABLE `contacto` (
  `Id` VARCHAR(50) NOT NULL, 
  `Tipo_id` VARCHAR(20) NOT NULL,
  `Telefono` VARCHAR(20) NOT NULL, 
  `Correo` VARCHAR(255) DEFAULT NULL,
  `Direccion` VARCHAR(255) NOT NULL, 
  `Ciudad` VARCHAR(100) NOT NULL,
  `Departamento` VARCHAR(100) NOT NULL,
  `Nacionalidad` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `contacto`
--

INSERT INTO `contacto` (`Id`, `Tipo_id`, `Telefono`, `Correo`, `Direccion`, `Ciudad`, `Departamento`, `Country`) VALUES
('1036678350', 'CC', 300231230, 'santiqupgui@gmail.com', 'carrera 54A #63-10', 'itagui', 'Antioquia', 'Colombia'),
('9010193734', 'NIT', 316812037, 'contacto@experimentailty.', 'calle 16 #45-85', 'Medellin', 'Antioquia', 'Colombia'),
('1036678350', 'CC', 3001234567, 'juan.perez@example.com', 'Calle 123 #45-67', 'Bogotá', 'Cundinamarca', 'Colombia');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `envios`
--

DROP TABLE IF EXISTS `envios`;

CREATE TABLE `envios` (
  `Id` INT AUTO_INCREMENT PRIMARY KEY, -- Clave primaria con AUTO_INCREMENT
  `Nombres` VARCHAR(100) NOT NULL, -- Aumentado a 100 caracteres para nombres largos
  `Apellidos` VARCHAR(100) NOT NULL, -- Aumentado a 100 caracteres para apellidos largos
  `Cedula` VARCHAR(20) NOT NULL, -- Aumentado a 20 caracteres para mayor flexibilidad
  `Correo` VARCHAR(255) NOT NULL, -- Aumentado a 255 caracteres para correos largos
  `Direccion_Envio` VARCHAR(255) NOT NULL, -- Aumentado a 255 caracteres para direcciones completas
  `Estado` ENUM('En tránsito', 'Entregado', 'Cancelado') NOT NULL DEFAULT 'En tránsito', -- Usar ENUM para estados predefinidos
  `Country` VARCHAR(100) NOT NULL, -- Mantener 100 caracteres para el país
  `Fecha_Envio` DATETIME(6) NOT NULL, -- Fecha y hora del envío
  `Fecha_Entrega` DATETIME(6) DEFAULT NULL, -- Fecha y hora de la entrega (puede ser NULL si no se ha entregado)
  `ID_Vendedor` INT NOT NULL, -- Relación con la tabla `vendedor`
  `ID_Estado_De_Envio` INT NOT NULL, -- Relación con la tabla `estado de envio`
  `ID_Pedidos` INT NOT NULL, -- Relación con la tabla `pedidos`
  FOREIGN KEY (`ID_Vendedor`) REFERENCES `vendedor`(`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`ID_Estado_De_Envio`) REFERENCES `estado de envio`(`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`ID_Pedidos`) REFERENCES `pedidos`(`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `envios`
--

INSERT INTO `envios` (`Nombres`, `Apellidos`, `Cedula`, `Correo`, `Direccion_Envio`, `Estado`, `Country`, `Fecha_Envio`, `Fecha_Entrega`, `ID_Vendedor`, `ID_Estado_De_Envio`, `ID_Pedidos`) VALUES 
('Juan', 'Pérez', '123456789', 'juan.perez@example.com', 'Calle 123 #45-67', 'En tránsito', 'Colombia', '2025-03-08 10:00:00', '2025-03-10 15:00:00', 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado de envio`
--

DROP TABLE IF EXISTS `estado_de_envio`;

CREATE TABLE `estado_de_envio` (
  `Id` int(30) NOT NULL,
  `Numero De Guia` varchar(20) NOT NULL,
  `Bodega` varchar(20) NOT NULL,
  `Ruta` varchar(20) NOT NULL,
  `Entregado` varchar(10) NOT NULL,
  `ID_Envios` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

DROP TABLE IF EXISTS `inventario`;

CREATE TABLE `inventario` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `Color` VARCHAR(50) NOT NULL,
  `Diseño` VARCHAR(50) NOT NULL, 
  `Calidad` VARCHAR(50) NOT NULL, 
  `Tamaño` VARCHAR(50) DEFAULT NULL,
  `Stock` INT NOT NULL,
  `precio` DOUBLE NOT NULL,
  `ID_Productos` INT NOT NULL,
  `Url_imagen` TEXT DEFAULT NULL,
  `Descripcion` TEXT DEFAULT NULL,
  `Ancho` DOUBLE DEFAULT NULL,
  `Alto` DOUBLE DEFAULT NULL,
  `Largo` DOUBLE DEFAULT NULL,
  FOREIGN KEY (`ID_Productos`) REFERENCES `productos`(`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `inventario`
--

INSERT INTO `inventario` (`id`, `Color`, `Diseño`, `Calidad`, `Tamaño`, `Stock`, `precio`, `ID_Productos`, `Url_imagen`, `Descripcion`, `Ancho`, `Alto`, `Largo`) VALUES
(1, 'rojo', 'cortina de humo', 'AAA', 'Enorme', 10, 0, 1, 'https://www.telesurtv.net/__export/1431099885068/sites/telesur/img/blog/2015/05/08/cortina_de_humo.jpg_916636689.jpg', 'Te oculta para no llamar la atencion', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario_y_proveedor`
--

DROP TABLE IF EXISTS `inventario_y_proveedor`;

CREATE TABLE `inventario_y_proveedor` (
  `id_proveedor` int(30) NOT NULL,
  `id_inventario` int(30) NOT NULL,
  `costo` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `inventario_y_proveedor`
--

INSERT INTO `inventario_y_proveedor` (`id_proveedor`, `id_inventario`, `costo`) VALUES
(1, 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

DROP TABLE IF EXISTS `pagos`;

CREATE TABLE `pagos` (
  `Id` int(30) NOT NULL,
  `Fecha Pagos` datetime(6) NOT NULL,
  `Puntos De Pago` varchar(10) NOT NULL,
  `ID_Cliente` int(30) NOT NULL,
  `ID_Envios` int(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;

CREATE TABLE `pedidos` (
  `Id` int(30) NOT NULL,
  `Fecha Realizacion` datetime(6) NOT NULL,
  `Estado` varchar(20) NOT NULL,
  `Total` float NOT NULL,
  `ID_Vendedor` int(11) NOT NULL,
  `ID_Cortinas` int(11) NOT NULL,
  `ID_Cliente` int(11) NOT NULL,
  `ID_Estado De Pedido` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

DROP TABLE IF EXISTS `productos`;

CREATE TABLE `productos` (
  `Id` INT AUTO_INCREMENT PRIMARY KEY,
  `Nombre` VARCHAR(100) NOT NULL,
  `Descripcion` TEXT NOT NULL,
  `Url_imagen` TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`Id`, `Nombre`, `Descripcion`, `Url_imagen`) VALUES
(1, 'cortina', 'pedazo de tela para tapar la l', 'https://i.pinimg.com/736x/f9/15/00/f91500e09cfc219f6cbd73a49da37060.jpg'),
(2, 'gancho', 'agarre con forma curva utiliza', 'https://m.media-amazon.com/images/I/51d4KrrWSoL._AC_SL1000_.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

DROP TABLE IF EXISTS `proveedor`;

CREATE TABLE `proveedor` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `Cargo` VARCHAR(100) NOT NULL,
  `ID_Contacto_empresa` VARCHAR(50) NOT NULL,
  `ID_Contacto_representante` VARCHAR(50) NOT NULL,
  FOREIGN KEY (`ID_Contacto_empresa`) REFERENCES `contacto`(`Id`),
  FOREIGN KEY (`ID_Contacto_representante`) REFERENCES `contacto`(`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`id`, `Cargo`, `ID_Contacto_empresa`, `ID_Contacto_representante`) VALUES
(1, 'el del tinto', '9010193734', '1036678350');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitud`
--

DROP TABLE IF EXISTS `solicitud`;

CREATE TABLE `solicitud` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `fecha_solicitud` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  `tipo_solicitud` VARCHAR(100) NOT NULL, 
  `nombre_completo` VARCHAR(255) NOT NULL,
  `correo_electronico` VARCHAR(255) NOT NULL,
  `telefono` VARCHAR(50) NOT NULL, 
  `direccion` VARCHAR(255) DEFAULT NULL,
  `nombre_producto` VARCHAR(255) DEFAULT NULL,
  `id_factura` INT DEFAULT NULL,
  `motivo` TEXT DEFAULT NULL,
  `estado` VARCHAR(50) DEFAULT 'PENDIENTE', 
  `imagenes_base64` LONGTEXT DEFAULT NULL,
  FOREIGN KEY (`id_factura`) REFERENCES `factura`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `solicitud`
--

INSERT INTO `solicitud` (`id`, `fecha_solicitud`, `tipo_solicitud`, `nombre_completo`, `correo_electronico`, `telefono`, `direccion`, `nombre_producto`, `id_factura`, `motivo`, `estado`, `imagenes_base64`) VALUES
(1, '2025-03-08 03:14:32', 'instalacion', 'santiago quiroz upegui', 'squirozu@unal.edu.co', '3002312301', 'carrera54A #63-10', NULL, NULL, NULL, NULL, 'me quede sin decoraciones :c', 'PENDIENTE', NULL),
(2, '2025-03-08 04:04:08', 'instalacion', 'santiago helicoptero quiroz upegui', 'squirozu@unal.edu.co', '3002312301', 'carrera 54a #63-10', NULL, NULL, NULL, NULL, 'me quede sin instalación, ayudita', 'PENDIENTE', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

DROP TABLE IF EXISTS `usuario`;

CREATE TABLE `usuario` (
  `correo` VARCHAR(255) NOT NULL, 
  `contraseña` VARCHAR(255) NOT NULL, 
  `ID_Contacto` VARCHAR(50) NOT NULL,
  `Verificado` BOOLEAN DEFAULT FALSE, 
  PRIMARY KEY (`correo`),
  FOREIGN KEY (`ID_Contacto`) REFERENCES `contacto`(`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vendedor`
--

DROP TABLE IF EXISTS `vendedor`;

CREATE TABLE `vendedor` (
  `Id` int(30) NOT NULL,
  `ID_Contacto` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `administrador`
--
ALTER TABLE `administrador`
  ADD KEY `administrador-contacto` (`ID_Contacto`);

--
-- Indices de la tabla `carrito_compras`
--
ALTER TABLE `carrito_compras`
  ADD KEY `carrito_compras_ibfk_1` (`ID_Productos`),
  ADD KEY `carrito-pedidos` (`ID_Pedidos`),
  ADD KEY `carrito-inventario` (`ID_Inventario`);

--
-- Indices de la tabla `categoria`
--
ALTER TABLE otra_tabla DROP FOREIGN KEY fk_categoria;
DROP TABLE IF EXISTS categoria;
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `categoria_y_producto`
--
ALTER TABLE `categoria_y_producto`
  ADD PRIMARY KEY (`ID_Productos`,`ID_Categoria`),
  ADD KEY `ID_Categoria` (`ID_Categoria`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE otra_tabla ADD CONSTRAINT nombre_de_la_clave_foranea FOREIGN KEY (cliente_id) REFERENCES cliente(id);
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `ID_Contacto` (`ID_Contacto`);

--
-- Indices de la tabla `contacto`
--
ALTER TABLE `contacto`
  ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `envios`
--
ALTER TABLE `envios`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_ID_Estado De Envio` (`ID_Estado De Envio`),
  ADD KEY `FK_ID_Vendedor` (`ID_Vendedor`),
  ADD KEY `envios-pedidos` (`ID_Pedidos`);

--
-- Indices de la tabla `estado de envio`
--
ALTER TABLE `estado de envio`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_ID_Envios` (`ID_Envios`);

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventario-producto` (`ID_Productos`);

--
-- Indices de la tabla `inventario_y_proveedor`
--
ALTER TABLE `inventario_y_proveedor`
  ADD PRIMARY KEY (`id_proveedor`,`id_inventario`),
  ADD KEY `inventario_y_proveedor_ibfk_2` (`id_inventario`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_ID_Cliente` (`ID_Cliente`),
  ADD KEY `pagos-envios` (`ID_Envios`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_ID_Estado De Pedido` (`ID_Estado De Pedido`),
  ADD KEY `FK_ID Cliente` (`ID_Cliente`),
  ADD KEY `FK_ID_Cortinas` (`ID_Cortinas`),
  ADD KEY `FK_ID_Vendedor` (`ID_Vendedor`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proveedor-empresa` (`ID_Contacto_empresa`),
  ADD KEY `proveedor-representante` (`ID_Contacto_representante`);

--
-- Indices de la tabla `solicitud`
--
ALTER TABLE `solicitud`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`correo`),
  ADD KEY `usuario-contacto` (`ID_Contacto`);

--
-- Indices de la tabla `vendedor`
--
ALTER TABLE `vendedor`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `vendedor-contacto` (`ID_Contacto`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `envios`
--
ALTER TABLE `envios`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estado de envio`
--
ALTER TABLE `estado de envio`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `inventario`
--
ALTER TABLE `inventario`
  MODIFY `id` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `id` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `solicitud`
--
ALTER TABLE `solicitud`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `vendedor`
--
ALTER TABLE `vendedor`
  MODIFY `Id` int(30) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `administrador`
--
ALTER TABLE `administrador`
  ADD CONSTRAINT `administrador-contacto` FOREIGN KEY (`ID_Contacto`) REFERENCES `contacto` (`Id`);

--
-- Filtros para la tabla `carrito_compras`
--
ALTER TABLE `carrito_compras`
  ADD CONSTRAINT `carrito-inventario` FOREIGN KEY (`ID_Inventario`) REFERENCES `inventario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `carrito-pedidos` FOREIGN KEY (`ID_Pedidos`) REFERENCES `pedidos` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `categoria_y_producto`
--
ALTER TABLE `categoria_y_producto`
  ADD CONSTRAINT `categoria_y_producto_ibfk_1` FOREIGN KEY (`ID_Categoria`) REFERENCES `categoria` (`id`),
  ADD CONSTRAINT `categoria_y_producto_ibfk_2` FOREIGN KEY (`ID_Productos`) REFERENCES `productos` (`Id`);

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`ID_Contacto`) REFERENCES `contacto` (`Id`);

--
-- Filtros para la tabla `envios`
--
ALTER TABLE `envios`
  ADD CONSTRAINT `envios-pedidos` FOREIGN KEY (`ID_Pedidos`) REFERENCES `pedidos` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `envios_ibfk_2` FOREIGN KEY (`ID_Estado De Envio`) REFERENCES `estado de envio` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD CONSTRAINT `inventario-producto` FOREIGN KEY (`ID_Productos`) REFERENCES `productos` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `inventario_y_proveedor`
--
ALTER TABLE `inventario_y_proveedor`
  ADD CONSTRAINT `inventario_y_proveedor_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `inventario_y_proveedor_ibfk_2` FOREIGN KEY (`id_inventario`) REFERENCES `inventario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `pagos-envios` FOREIGN KEY (`ID_Envios`) REFERENCES `envios` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`ID_Cliente`) REFERENCES `cliente` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`ID_Cliente`) REFERENCES `cliente` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pedidos_ibfk_3` FOREIGN KEY (`ID_Vendedor`) REFERENCES `vendedor` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD CONSTRAINT `proveedor-empresa` FOREIGN KEY (`ID_Contacto_empresa`) REFERENCES `contacto` (`Id`),
  ADD CONSTRAINT `proveedor-representante` FOREIGN KEY (`ID_Contacto_representante`) REFERENCES `contacto` (`Id`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario-contacto` FOREIGN KEY (`ID_Contacto`) REFERENCES `contacto` (`Id`);

--
-- Filtros para la tabla `vendedor`
--
ALTER TABLE `vendedor`
  ADD CONSTRAINT `vendedor-contacto` FOREIGN KEY (`ID_Contacto`) REFERENCES `contacto` (`Id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `fecha` DATE NOT NULL,
  `cliente_id` INT NOT NULL,
  `total` DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (`cliente_id`) REFERENCES `cliente`(`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_factura`
--

CREATE TABLE `detalle_factura` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `factura_id` INT NOT NULL,
  `producto_id` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio` DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (`factura_id`) REFERENCES `factura`(`id`),
  FOREIGN KEY (`producto_id`) REFERENCES `productos`(`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------